
function ext()
% get polymer configurations

  flist=dir("poly.1");

%nfile is the number of polymers
  nfile = size(flist,1);

 %Loop for all polymers
 for kk=1:nfile
    fname=fullfile(".", flist(kk).name);
    data = file2data(fname);
    if (~exist("extfun", "var"))
      extfun = getpolymerext(data);
      rg2 = getrg2(data);
    else
      extfun = extfun + getpolymerext(data);
      rg2 = rg2 + getpolymerext(data);
    endif
  endfor

 nb=getnbead(fname);
printf("Polymer with beads %d",nb);
printf(" the end-to-end distance is:");
extfun=extfun/nfile;
rg2 = rg2/nfile;
dtime = 0:size(extfun, 1)-1;
 dlmwrite( "extx.dat", [dtime', extfun], ' ', "precision", "%e");
 dlmwrite( "rg2.dat",   [dtime', rg2], ' ', "precision", "%e");
endfunction

function data = file2data(fname)
  if (~exist(fname, "file"))
    error("cannot one file: %s\n", fname);
  endif
% get number of beads
  nb=getnbead(fname);
  warning("ID1", "number of beads is %d", nb);
  dim=3;
  % read data without space between rows
  
  data = dlmread(fname);
  
  % keep only x and y and z
  data = data(:, 1:dim);
  nsnap = size(data, 1)/nb;
  data = permute(reshape(data(:,:)', 3, nb, nsnap), [3, 2, 1]);
  warning("data structure: [%d %d %d]", size(data));
  % data structure is 
  % data ( isnaphot, ibead, dim )
endfunction

function [extfun] = getpolymerext(data)
  % the number of snapshots
  %the end-to-end distance  
  Rhead = squeeze(data(:, 1, :));
  Rtail = squeeze(data(:, end, :));
  Re2e = Rtail - Rhead;
  extfun=   sqrt(sumsq (Re2e, 2));
endfunction

function Rg2 = getrg2(data)
  nb = size(data, 2);
  Rcom = mean(data, 2);
  Rincm = data - repmat(Rcom, [1, nb, 1]);
  Rg2 = mean(sumsq(Rincm, 3), 2);
endfunction

function Rext = Rext(data, dim)
  nb = size(data, dim);
  R = squeeze(data(:, :, dim));
  
  Rext = max(R') - min(R');
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
