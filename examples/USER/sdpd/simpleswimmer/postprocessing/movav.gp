f(nb,ns,v)=sprintf("../supermuc-data/c3e2-nbeads%i-nsolvent%i-K_wave500-T_wave20-v_wave%i-dsize150mass3/prints/movingave.dat", nb,ns,v)
mfile(nb,ns,v)=sprintf("../supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave450-dsize150mass3/prints/moments_swimmercom.dat", nb, ns, v)

nst=200
dt=3.1999999999999995e-5
Nprint=500

set xlabel "time"
set ylabel "velocity of the CM of the swimmer, X"
plot [][-5.5:5.5] \
     nb=10, ns=20, v=150, \
     mfile(nb, ns, v) u 1:5 w p ps 1 t sprintf("moving average, kernel: %5.2e", ns*dt*Nprint), \
     f(nb, ns, v) w l lw 2 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     0 w l lw 2 t "" 

call "saver.gp" "movav"     
