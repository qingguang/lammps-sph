# 10: sph approximation
# 11: exact
# 12: error
# 

set term x11 1
set xlabel "x"
set ylabel "error, L2"
plot [][1e-4:]  \
     "~/dump.nx15" u 3:12 t "nx=15, BN", \
     "~/dump.nx15.grid" u 3:12 w p pt 5 ps 2 t "nx=15, grid", \
     "~/dump.nx30" u 3:12 t "nx=30, BN", \
     "~/dump.nx30.grid" u 3:12 w p pt 7 ps 2 t "nx=30, grid", \
     "~/dump.nx60" u 3:12 t "nx=30, BN", \
     "~/dump.nx60.grid" u 3:12 w p ps 2 t "nx=60, grid"

set term x11 2
set xlabel "r/h"
set ylabel "rdf"
h15 = 0.12
h30 = h15/2.0
h60 = h15/4.0
plot "<tail -n 50 ~/lrdf.nx15" u ($2/h15):3 w lp t "nx=15", \
     "<tail -n 50 ~/lrdf.nx60" u ($2/h60):3 w lp t "nx=60"

set term x11 3
set xlabel "x"
set ylabel "dA/dx"
set key center
plot "~/dump.nx15" u 3:10 t "SPH", \
     "" u 3:11 t "exact", \
     "~/dump.nx30" u 3:10 t "SPH", \
     "" u 3:11 t "exact"