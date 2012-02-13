function ext()
% get polymer configurations

  flist=dir("pdata/poly.*");

%nfile is the number of polymers
  nfile = size(flist,1);

 %Loop for all polymers
 for kk=1:nfile-1
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
  data = reshape(data'(:), nb, 3, []);

  % the number of snapshots
  nsnap = size(data, 3);
  extfun = zeros(nsnap, 1);
%the end-to-end distance  
extfun=sqrt(getend(data,nb,dim,nsnap)); 
% extfun(:) = max(data(:, 1, :)) - min(data(:, 1, :));

endfunction
%Get the end-to-end distance over all snapshots
function [endtoend]=getend(data,nb,dim,nsnap)
endtoend=0;
%(x1-x2)^2
for j=1:nsnap
for i=1:dim
endtoend+=(data(i,1,j)-data(nb-3+i,dim,j)).^2; 
end
end
endtoend=endtoend/nsnap;
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
