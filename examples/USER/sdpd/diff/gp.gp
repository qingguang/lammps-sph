# 10: sph approximation
# 11: exact
# 12: error
# 

dfile(n)=sprintf("<sort -k 3 c1e3-ndim2-eta8.0-sdpd_background0.0-nx30-n%s/dump00040000.dat", n)

sgr_file(n)=sprintf("<sort -k 3 c1e3-ndim2-eta8.0-sdpd_background0.0-nx30-n%s/dump00000000.dat.smothed", n)
sbn_file(n)=sprintf("<sort -k 3 c1e3-ndim2-eta8.0-sdpd_background0.0-nx30-n%s/dump00040000.dat.smothed", n)

set term x11 1
set key left
set log y
set xlabel "x"
set ylabel "L2-norm"
plot [][1e-6:1.0] \
     sbn_file("3.0") u 1:(abs($3-$5)) w p ps 3 t "n=3, |SPH(relaxed)-smothed|", \
     sbn_file("4.0") u 1:(abs($3-$5)) w p ps 3 t "n=4, |SPH(relaxed)-smothed|", \
     sbn_file("6.0") u 1:(abs($3-$5)) w p ps 3 t "n=6, |SPH(relaxed)-smothed|"
call "saver.gp" "relaxed"
system("epstopdf relaxed.eps")     

set term x11 2
set key left
set log y
set xlabel "x"
set ylabel "L2-norm"
plot [][1e-6:1.0] \
     sgr_file("3.0") u 1:(abs($3-$5)) w p ps 3 t "n=3, |SPH(grid)-smothed|", \
     sgr_file("4.0") u 1:(abs($3-$5)) w p ps 3 t "n=4, |SPH(grid)-smothed|", \
     sgr_file("6.0") u 1:(abs($3-$5)) w p ps 3 t "n=6, |SPH(grid)-smothed|"
call "saver.gp" "grid"
system("epstopdf grid.eps")
     
set term x11 3
set key center top
unset log
set xlabel "x"
set ylabel "dA/dx"
plot \
     dfile("3.0") u 3:10 w l lc 1 t "nx=30, n=3, relaxed", \
     sbn_file("3.0") u 1:3 w p pt 6 lc 1 t "n=3, smothed", \
     dfile("4.0") u 3:10 w l lc 2 t "nx=30, n=4, relaxed", \
     sbn_file("4.0") u 1:3 w p pt 6 lc 2 t "n=4, smothed", \
     dfile("6.0") u 3:10 w l lc 3 t "nx=30, n=6, relaxed", \
     sbn_file("6.0") u 1:3 w p pt 6 lc 3 t "n=6, smothed"
     
call "saver.gp" "dAdx"
system("epstopdf dAdx.eps")

set term x11 4
set key center top
unset log
set xlabel "x"
set ylabel "dA/dx"
plot [0.4:0.8][-5.5:-4.0] \
     dfile("3.0") u 3:10 w l lc 1 t "nx=30, n=3, relaxed", \
     sbn_file("3.0") u 1:3 w p pt 6 lc 1 t "n=3, smothed", \
     dfile("4.0") u 3:10 w l lc 2 t "nx=30, n=4, relaxed", \
     sbn_file("4.0") u 1:3 w p pt 6 lc 2 t "n=4, smothed", \
     dfile("6.0") u 3:10 w l lc 3 t "nx=30, n=6, relaxed", \
     sbn_file("6.0") u 1:3 w p pt 6 lc 3 t "n=6, smothed"
     
call "saver.gp" "zoomed"
system("epstopdf zoomed.eps")




