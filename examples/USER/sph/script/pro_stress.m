close all;
clear all;
outdirname='~/sph-projection/'%polymer6/stress-x-y/';
filelist=dir(fullfile(outdirname, 'stress*.prj'));
nfile=length(filelist)
np=96;
L=8e-2;
%np=72;
%nfile=1
for nid=1:nfile
    X{nid}=(L/np)/2:L/np:L-(L/np)/2;
    Y{nid}=(L/np)/2:L/np:L-(L/np)/2;
    Sx{nid}=zeros(np,np);
    Sy{nid}=zeros(np,np);
    Sxy{nid}=zeros(np,np);
end
for nid=1:nfile
    name=filelist(nid).name;  
    disp(name);
    A = importdata(fullfile(outdirname, name));
j=0;
k=0;    
for i=1:length(A)
    j=floor(A(i,1)/(L/np))+1;
    k=floor(A(i,2)/(L/np))+1;
    Sx{nid}(k,j)=A(i,3);
    Sy{nid}(k,j)=A(i,4);
end
end
%for nid=1:nfile

Xsum=zeros();
Ysum=zeros();
Sxsum=zeros();
Sysum=zeros();
Sxysum=zeros();
for nid=1:nfile
Xsum=Xsum+X{nid};
Ysum=Ysum+Y{nid};
Sxsum=Sxsum+Sx{nid};
Sysum=Sysum+Sy{nid};
Sxysum=Sxysum+Sxy{nid};
end
Xsum=Xsum/nfile;
Ysum=Ysum/nfile;
Sxsum=Sxsum/nfile;
Sysum=Sysum/nfile;
pcolor(Xsum,Ysum,Sxsum+Sysum), shading interp,
%axis([0,0.026,0.011,0.016]);
title('Polymer Stress S11+S22 in 4-roller-flow with particles=96*96 and 6-bead-polymer');
figure;
pcolor(Xsum,Ysum,Sysum); shading interp
Sxmid=zeros();
Symid=zeros();
ovag=2;
lb=np/2-ovag;
ub=np/2+ovag;
for i=lb:ub
    Sxmid=Sxsum(i,:)+Sxmid;
    Symid=Sysum(i,:)+Symid;
end
num=ub-lb+1;
figure;
plot(Xsum,Sxmid/num+Symid/num,'O--');
title('Polyme stress S11+S22 along the center line y=L/2 with 12-bead-polymer');
