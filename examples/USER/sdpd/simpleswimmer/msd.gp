set xlabel "time"
set ylabel "MSD^{1/2}"

f(nb,ns,v)= \
sprintf("<awk 'NF==2{print $1, sqrt($2)}' supermuc-data/c3e2-nbeads%i-nsolvent%i-K_wave500-T_wave20-v_wave%i-dsize150mass3/prints/msd.dat", nb,ns,v)

set key left
set size 0.75
plot [0:10] \
     v=10, \
     nb=0,  ns=20,  f(nb, ns, v) w l lw 3 lc 1 lt 4 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns= 20, f(nb, ns, v) w l lw 3 lc 2 lt 4 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns= 5, f(nb, ns, v) w l lw 3 lc 3 lt 4 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     v=50, \
     nb=0,  ns=20, f(nb, ns, v) w l lw 3 lc 1 lt 1 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns=20,  f(nb, ns, v) w l lw 3 lc 2 lt 1 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns=5, f(nb, ns, v) w l lw 3 lc 3 lt 1 t sprintf("v = %4.0f, c_p = %3.0f\%", v,  100*(nb+0.0)/(nb+ns)), \
     v=150, \
     nb=0,  ns=20,  f(nb, ns, v) w l lw 3 lc 1 lt 2 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns=20,  f(nb, ns, v) w l lw 3 lc 2 lt 2 t sprintf("v = %4.0f, c_p = %3.0f\%", v, 100*(nb+0.0)/(nb+ns)), \
     nb=10, ns=5, f(nb, ns, v) w l lw 3 lc 3 lt 2 t sprintf("v = %4.0f, c_p = %3.0f\%", v,  100*(nb+0.0)/(nb+ns))

call "~/google-svn/gnuplot/saver.gp" "msd"
