set xlabel "X"
set ylabel "Y"

f(nb,ns,v)= \
sprintf("supermuc-data/c3e2-nbeads%i-nsolvent%i-K_wave500-T_wave20-v_wave%i-dsize150mass3/prints/moments_swimmercom.dat", nb,ns,v)

disp(nb,ns,v)= \
sprintf("<awk 'NR>100' supermuc-data/c3e2-nbeads%i-nsolvent%i-K_wave500-T_wave20-v_wave%i-dsize150mass3/prints/moments_swimmercom.dat | awk -f disp.awk ", nb,ns,v)

set size sq
set key left
set size 0.75
x1=0
x2=28.5
y1=-20
plot [x1:x2][y1:y1+(x2-x1)] \
     v=50, \
     disp(0, 20,  v) u 2:3 w l lw 3 t sprintf("c_p = %3.0f\%", 0), \
     disp(10, 5,  v) u 2:3 w l lw 3 t sprintf("c_p = %3.0f\%", 1.0/3.0 * 100), \
     disp(10, 20, v) u 2:3 w l lw 3 t sprintf("c_p = %3.0f\%", 2.0/3.0 * 100)

call "~/google-svn/gnuplot/saver.gp" "traj"     
     
     
