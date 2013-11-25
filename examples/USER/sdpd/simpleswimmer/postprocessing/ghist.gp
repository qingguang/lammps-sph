f(nb,ns,v)=sprintf("../supermuc-data/c3e2-nbeads%i-nsolvent%i-K_wave500-T_wave20-v_wave%i-dsize150mass3/prints/vx-mom.hist", nb,ns,v)

nst=200
dt=3.1999999999999995e-5
Nprint=500

set ylabel "velocity of the CM of the swimmer, X"
set ylabel "counts"
plot \
     nb=10, ns=20, v=150, \
     f(nb, ns, v) u 1:3 w l lw 2 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns))


call "saver.gp" "ghist"
