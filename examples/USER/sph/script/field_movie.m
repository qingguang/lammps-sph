dbox = 0.001;
box_size = [-dbox, L+dbox, -dbox, L+dbox];
makefile = true;

try 
    aviobj = close(aviobj);
end

if makefile
    aviobj = avifile('field.avi');
end

fig = figure;
%set(gca,)

% the number of particles
N = length(X);

% number of timesteps 
M = length(X{1});

%Ex_num = reshape(cell2mat(Ex), M, N);
%Ey_num = reshape(cell2mat(Ey), M, N);

nid = 1;

for nid=1:N
    hold off
    %cav{nid} = curl(X{nid},Y{nid},Ux{nid},Uy{nid});
    pcolor(X{nid},Y{nid},cav{nid}); shading interp;
    % Create colorbar
    colorbar;%('peer',axes1);
    caxis([-2,2]);
    title('Vorticity field for Polymer Solution')
    %hold on
    %quiver(X{nid},Y{nid},Ux{nid},Uy{nid},'k')
    timesum=nid*10000;
title(['timestep is:',num2str(timesum)]);
hold off
colormap jet
    axis([box_size]);
    if makefile 
        frame = getframe(gcf);  
        aviobj = addframe(aviobj,frame);
    else
        pause(0.1);
    end
end

if makefile
    aviobj = close(aviobj);
    disp('field created')
end