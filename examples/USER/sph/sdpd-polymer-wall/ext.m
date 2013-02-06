function ext()
% get polymer configurations
  flist=dir("pdata/poly.*");

  nfile = size(flist,1);
  %for kk=1:nfile-1
  for kk=1:1
    fname=fullfile("pdata", flist(kk).name);

    if (kk==1)
      extfun = getpolymerext(fname);
    else
      printf("kk=%d\n", kk);
      extfun = extfun + getpolymerext(fname);
    endif
  end
  dtime = 0:size(extfun, 1)-1;
  dlmwrite( "extx.dat", [dtime', extfun/nfile], ' ', "precision", "%e");

endfunction

function [extfun] = getpolymerext(fname)
% get number of beads
  nb=getnbead(fname);
  
  % read data
  data = dlmread(fname);
  
  % keep only x and y
  data = data(:, 1:2);
  data = reshape(data'(:), nb, 2, []);

  % the number of snapshots
  nsnap = size(data, 3);
  extfun = zeros(nsnap, 1);
  extfun(:) = max(data(:, 1, :)) - min(data(:, 1, :));
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