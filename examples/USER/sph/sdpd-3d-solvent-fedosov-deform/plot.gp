# domain length
Ly = 0.0009015;

# deform rate
R = 50

plot \
     "<./lastvav.sh vx.av" u ($1*Ly/100):4, \
        R*(x-Ly/2.0)