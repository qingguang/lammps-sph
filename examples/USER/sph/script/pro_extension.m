 close all;
clear all;
outdirname='~/sph-projection/';%/polymer6';
filelist=dir(fullfile(outdirname, 'exten00*.del'));
nfile=length(filelist) ;
X=zeros();
Y=zeros();
k=1; 
for nid=1:nfile
    name=filelist(nid).name;  
    disp(name);
    A = importdata(fullfile(outdirname, name));
    X(1,k)=A(1,3);
    Y(1,k)=A(2,3);
    k=k+1;
end
Ext=Y-X-(Y(1,1)-X(1,1));
N=500;
T=(1:(nfile-N+1)).*1000*2.08333325e-05;
tau=60*1000*2.08333325e-05;
a=1;
plot( T, (Ext(N:end)-Ext(end))/(Ext(N)-Ext(end)),'*b');
hold on;
plot( T, a*exp(-T/tau),'-r');
tau