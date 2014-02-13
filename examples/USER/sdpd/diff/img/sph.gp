set term postscript eps enhanced color 18
set output "sph.eps"

set multiplot layout 3, 1
set log
set xlabel "dx/cutoff"
set ylabel "L_1 (SPH-exact) "
set xtics (3.5, 4.0, 4.5, 5.0, 5.5)
set ytics (1e-2 , 1e-3)
plot [3.4:5.6][5e-4:1.2e-2] "l1.dat" t "" w lp lw 3, 5*x**(-5.5) t "x^{-5.5}" w l lw 2

unset log
set xtics (0.0, 1.0, 2.0, 3.0, 4.0, 5.0)
set ytics (0.0, 1.0, 2.0, 3.0)
set ytics add ("     " 1.5)
set xlabel "dx"
set ylabel "RDF"
dx = 1.2/30
plot [][-1e-4:] "rdf.dat" u ($1/dx):2 w l lw 3 t ""

unset xtics
unset ytics
set xlabel "x"
set ylabel "y"
plot [0:1.2][0:0.4] "dump.dat" w p pt 6 t ""