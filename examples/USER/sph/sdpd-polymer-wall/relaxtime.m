function relaxtime()
% get polymer configurations
  flist=dir("pdata/poly.*");

  nfile = size(flist,1);
  for kk=1:nfile-1
    fname=fullfile("pdata", flist(kk).name);

    if (kk==1)
      cr = getonecorr(fname);
    else
      printf("kk=%d\n", kk);
      cr = cr + getonecorr(fname);
    endif
  end
  dtime = 0:size(cr, 1)-1;
  plot (dtime, cr/nfile);

  dlmwrite( "corr.dat", [dtime', cr/nfile], ' ');

endfunction

function [corrfun] = getonecorr(fname)
% get number of beads
  nb=getnbead(fname);
  
  % read data
  data = dlmread(fname);
  
  % keep only x and y
  data = data(:, 1:2);
  data = reshape(data'(:), nb, 2, []);
  R = end2end(data);
  
  corrfun = vautocor(R);
endfunction

% get the number of beads
function [nbead] = getnbead(fname)
fid = fopen (fname);
  nbead=-1;
  do
    line = strtrim(fgetl(fid));
    nbead=nbead+1;
  until strcmp(line, "")
  fclose (fid);
endfunction

function [R] = end2end(data)
np=size(data, 3);
  Rhead = zeros(2, np);
  Rtail = zeros(2, np);
  Rhead(:, :) = data(1, :, :);
  Rtail(:, :) = data(end, :, :);

  R = Rtail' - Rhead';
endfunction


