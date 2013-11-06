function ext()
% get polymer configurations

  flist=dir("pdata/poly.1");

%nfile is the number of polymers
  nfile = size(flist,1);

 %Loop for all polymers
 for kk=1:nfile
 % for kk=1:1
    fname=fullfile("pdata", flist(kk).name);
%only one polymer
    if (kk==1)
      extfun = getpolymerext(fname);

%multi polymers,then do sum   
 else
      printf("kk=%d\n", kk);
      extfun = extfun + getpolymerext(fname);
    endif
  end
 nb=getnbead(fname);
printf("Polymer with beads %d",nb);
printf(" the end-to-end distance is:");
extfun=extfun/nfile
 % dtime = 0:size(extfun, 1)-1;
  %dlmwrite( "extx.dat", [dtime', extfun/nfile], ' ', "precision", "%e");

endfunction

function [extfun] = getpolymerext(fname)
% get number of beads
  nb=getnbead(fname);
  dim=3;
  % read data without space between rows
  
  data = dlmread(fname);
  
  % keep only x and y and z
  data = data(:, 1:dim);
%put different snapshot in cells the order is column order 1xyz2xyz3xyz.........
%the endend value is endbead-z
  nsnap = size(data, 1)/nb;
  data = permute(reshape(data(:,:)', 3, nb, nsnap), [3, 2, 1]);

  % rdata structure is 
  % rdata ( isnaphot, ibead, dim )


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


% get the number of beads
function [nbead] = getnbead(fname)
fid = fopen (fname);
  nbead=-1;
  do
    line = strtrim(fgetl(fid));
    nbead=nbead+1;
  until strcmp(line, "")
  fclose (fid);
%printf("Polymer with ",nbead,"beads");
endfunction
