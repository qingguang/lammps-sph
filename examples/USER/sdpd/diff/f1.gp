set macros
set log
set size 1.0
set xlabel "dx/cutoff"
set ylabel "L2(SPH-exact)"
set xtics (3.0, 4.0, 5.0, 6.0)
set key left bottom

ux='1:2'
plot [2.8:6.2][1e-4:10] \
     "<bash hm.sh relaxed laguerrewendland4eps" u @ux w lp t  "relaxed, laguerrewendland4eps", \
     "<bash hm.sh relaxed laguerre2wendland4eps" u @ux w lp  t  "relaxed, laguerre2wendland4eps", \
     "<bash hm.sh relaxed laguerre2wendland6eps" u @ux w lp  t  "relaxed, laguerre2wendland6eps", \
     "<bash hm.sh relaxed laguerre1wendland4eps" u @ux w lp  t  "relaxed, laguerre1wendland4eps", \
     "<bash hm.sh relaxed quintic" u @ux w lp t  "relaxed, quintic", \
     "<bash hm.sh relaxed wendland4" u @ux w lp t  "relaxed, wendland4", \
     "<bash hm.sh relaxed wcomb" u @ux w lp t  "relaxed, wcomb", \
     "<bash hm.sh relaxed blincomb" u @ux w lp t  "relaxed, blincomb", \
     10*x**(-6) t "-6"
call "~/google-svn/gnuplot/saver.gp" "f1"

set ylabel "L2(SPH-smothed)"
ux='1:3'
plot [2.8:6.2][1e-4:10] \
     "<bash hm.sh relaxed laguerrewendland4eps" u @ux w lp t  "relaxed, laguerrewendland4eps", \
     "<bash hm.sh relaxed laguerre2wendland4eps" u @ux w lp  t  "relaxed, laguerre2wendland4eps", \
     "<bash hm.sh relaxed laguerre1wendland4eps" u @ux w lp  t  "relaxed, laguerre1wendland4eps", \
     "<bash hm.sh relaxed wendland4" u @ux w lp t  "relaxed, wendland4", \
     "<bash hm.sh relaxed quintic" u @ux w lp t  "relaxed, quintic", \
     "<bash hm.sh grid laguerrewendland4eps" u @ux w lp  t  "grid, laguerrewendland4eps", \
     "<bash hm.sh grid laguerre2wendland4eps" u @ux w lp  t  "grid, laguerre2wendland4eps", \
     "<bash hm.sh grid laguerre1wendland4eps" u @ux w lp  t  "grid, laguerre1wendland4eps", \
     "<bash hm.sh grid quintic" u @ux w lp  t  "grid, quintic", \
     10*x**(-6) t "-6"
call "~/google-svn/gnuplot/saver.gp" "f2"

unset log
set size sq
set xlabel "x"
set ylabel "y"
plot "c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/dump00040000.dat" u 3:4 t ""
call "~/google-svn/gnuplot/saver.gp" "relaxed"

set size sq
set xlabel "x/dx"
set ylabel "rdf"
dx = 1.2/30
plot "<tail -n 50 c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/lrdf.dat" u ($2/dx):3 w lp t ""
call "~/google-svn/gnuplot/saver.gp" "rdf"