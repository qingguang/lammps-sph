function ext()
% get polymer configurations
  filemask = argv (){1};
  warning("ID1", "filemask is %s", filemask);
  flist=glob(filemask);

  % nfile is the number of polymers
  nfile = size(flist,1);
  if (nfile<1) 
    error("file list is empty");
  endif

 %Loop for all polymers
 for kk=1:nfile
    fname=flist{kk};
    warning("ID1", "======== processing file: %s", fname);
    data = file2data(fname);
    if (~exist("extfun", "var"))
     
      extfun = getpolymerext(data);% end to end distance
      rg2 = getrg2(data); %squared radius of gyration
      corfun = vautocor(gete2e(data)); %autocorrelation of end to end vetor
       rcom=vautocor(getcom(data));    
       Msd=getmsd(data);
 %ets=Rext(data, 3);%maximal extension in x direction   
 else
      extfun = extfun + getpolymerext(data);
      rg2 = rg2 + getrg2(data);
      corfun = corfun + vautocor(gete2e(data));
      rcom = rcom + vautocor(getcom(data));
      Msd=Msd+getmsd(data);    
 % ets=ets+Rext(data,3);
    endif
  endfor

 nb=getnbead(fname);
 warning("Polymer with beads %d",nb);
 extfun=extfun/nfile;
 rg2 = rg2/nfile;
 corfun = corfun/nfile;
rcom=rcom/nfile;
Msd=Msd/nfile;
 %ets=ets/nfile;
 dtime = 0:size(extfun, 1)-1;
 dtmsd=0:size(Msd)-1;
 dlmwrite( "extx.dat", [dtime', extfun], ' ', "precision", "%e");
 dlmwrite( "rg2.dat",   [dtime', rg2], ' ', "precision", "%e");
 dlmwrite( "corfun.dat",   [dtime', corfun], ' ', "precision", "%e");
 dlmwrite( "rcom.dat",   [dtime', rcom], ' ', "precision", "%e");
 dlmwrite( "Msd.dat",   [dtmsd', Msd], ' ', "precision", "%e");
% dlmwrite( "ets.dat",   [dtime', ets'], ' ', "precision", "%e");

endfunction

function data = file2data(fname)
  if (~exist(fname, "file"))
    error("cannot one file: %s\n", fname);
  endif
% get number of beads
  nb=getnbead(fname);
  warning("ID1", "number of beads is %d", nb);
  dim=2;
  % read data without space between rows
  
  data = dlmread(fname);
  
  % keep only x and y and z
  data = data(:, 1:dim);
  nsnap = size(data, 1)/nb;
  data = permute(reshape(data(:,:)', dim, nb, nsnap), [3, 2, 1]);
  warning("data structure: [%d %d %d]", size(data));
  % data structure is 
  % data ( isnaphot, ibead, dim )
endfunction

function [extfun] = getpolymerext(data)
  Re2e = gete2e(data);
  extfun=   sqrt(sumsq (Re2e, 2));
endfunction

function [Re2e] = gete2e(data)
  % the number of snapshots
  %the end-to-end distance  
  Rhead = squeeze(data(:, 1, :));
  Rtail = squeeze(data(:, end, :));
  Re2e = Rtail - Rhead;
endfunction

function Rcom=getcom(data)
Rcom=mean(data,2);
warning("size of Rcom:[%d %d %d]",size(Rcom));
endfunction
function Msd=getmsd(data)
Rcom=mean(data,2);
ndata=size(Rcom,1);
ndt=floor(ndata/4);
Msd=zeros(ndt,1);
%warning("size of Msd:[%d %d]",size(Msd));
for dt=1:ndt
%warning("size of Rcom:[%f %f]",Rcom(1,:,:));
totaldis=sumsq(Rcom(1+dt:end,:,:)-Rcom(1:end-dt,:,:),3);
warning("size of total:[%d %d]",size(totaldis));
Msd(dt)=mean(totaldis);
endfor
endfunction
function Rg2 = getrg2(data)
  nb = size(data, 2);
  Rcom = mean(data, 2);
  Rincm = data - repmat(Rcom, [1, nb, 1]);
  Rg2 = mean(sumsq(Rincm, 3), 2);
  
endfunction

function Rext = Rext(data, dim)
  nb = size(data, 2);
  R = squeeze(data(:, :, 1));
  
  Rext = max(R') - min(R');
endfunction


% get the number of beads
function [nbead] = getnbead(fname)
  fid = fopen (fname);
  if (fid == -1) 
    error("cannot open file: %s", fname);
  endif
  nbead=-1;
  do
    aux_line = fgetl(fid);
    if (isnumeric(aux_line))
      nbead = nbead + 1
      break;
    endif
    line = strtrim(aux_line);
    nbead=nbead+1;
  until strcmp(line, "")
  fclose (fid);
endfunction
