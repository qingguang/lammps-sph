close all;
clear all;
outdirname='~/sph-projection/';%/polymer6';
filelist=dir(fullfile(outdirname, 'dump1632*.del.prj'));
nfile=length(filelist) ;
X=cell(1, nfile);
Y=cell(1, nfile);
Ux=cell(1,nfile);
Uy=cell(1,nfile);
cav=cell(1,nfile);
np=96;
L=0.08;
%np=72;
%nfile=1
for nid=1:nfile
    X{nid}=(L/np)/2:L/np:L-(L/np)/2;
    Y{nid}=(L/np)/2:L/np:L-(L/np)/2;
    Ux{nid}=zeros(np,np);
    Uy{nid}=zeros(np,np);
    cav{nid}=zeros(np,np);
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
    Ux{nid}(k,j)=A(i,3);
    Uy{nid}(k,j)=A(i,4);
end
end
for nid=1:nfile
%nid=1;
cav{nid}=cav{nid}+curl(X{nid},Y{nid},Ux{nid},Uy{nid});
%= +
%[curlx{nid},curly{nid}] = curl(X{nid},Y{nid},Ux{nid},Uy{nid}), 
%cav{nid}=(curlx{nid}.^2+curly{nid}.^2)
%[curlx{nid},curly{nid}] = curl(X{nid},Y{nid},Ux{nid},Uy{nid});
%cav{nid}=(curlx{nid}-curly{nid});
end
%cav{nid}=cav{nid}./nfile
Xsum=zeros();
Ysum=zeros();
Uxsum=zeros();
Uysum=zeros();
cavsum=zeros();
for nid=1:nfile
Xsum=Xsum+X{nid};
Ysum=Ysum+Y{nid};
Uxsum=Uxsum+Ux{nid};
Uysum=Uysum+Uy{nid};
cavsum=cavsum+cav{nid};
end
Xsum=Xsum/nfile;
Ysum=Ysum/nfile;
Uxsum=Uxsum/nfile;
Uysum=Uysum/nfile;
cavsum=cavsum/nfile;
% for nid=2:2
% %subplot(1,nfile,nid);
% 
% hold on;
% %pcolor(X{nid},Y{nid},Ux{nid}); shading interp
% quiver(X{nid},Y{nid},Ux{nid},Uy{nid},'k');
% 
% %title(['Polymer9Force1000Vis0.002'])
% title(['Vorticity-Polymer18-F1-H5-T1e13-v1e-3-80-Re21'])
% xlabel('x'),ylabel('y');
% % title(['Vorticity-Solvent-T1e11K-Re0.5']);
% %title(['Vorticity-Solvent-F10-T1e14K-Re3.9']);
% hold off
% colormap jet
% end
%for i=1:nfile
  %  figure(i);
pcolor(Xsum,Ysum,cavsum); shading interp
hold on;
quiver(Xsum,Ysum,Uxsum,Uysum,'k');
title('Velocity and vorticity field in 4-roller-flow for pure solvent Re~0.2  Snapshot2')
%end
% for N=1:nfile
%     subplot(1,nfile,N)
% pcolor(X{N},Y{N},(Ux{N}+Uy{N})^2);shading interp
% %quiver(X{nid},Y{nid},Ux{nid},Uy{nid},'k')
% title(['timestep is:',num2str(N)])
% end
