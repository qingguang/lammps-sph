# domain length
dx=2.5e-5
Ly = 10*dx;

# deform rate
R = 50

plot \
     "<./lastvav.sh vx.av" u ($1*Ly/100):4, \
        R*(x-Ly/2.0)
