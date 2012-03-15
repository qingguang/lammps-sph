Lx = 0.0003606; 

plot \
     "<./lastvav.sh vx.av" u ($1*Lx/100):4, \
        50*(x-Lx/2.0)*2.5