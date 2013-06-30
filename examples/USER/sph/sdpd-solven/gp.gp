f = "/scratch/work/google-svn/latex/diff-paper/gnuplot/plotdata/rdf-data"
bgline="0.00 0.22 0.56"
cline="1.00e+01 2.78e+01"

set term x11 1
set key left
plot for [c in cline] for [bg in bgline] \
     sprintf("c%s-eta48.9-sdpd_background%s/all.msd", c, bg) w lp t sprintf("c=%s, bg=%s", c, bg), \
     1000.0*x*6.0/48.9

set term x11 2
set key right
plot [0:0.3] for [c in cline] for [bg in bgline] \
     sprintf("c%s-eta48.9-sdpd_background%s/rdf.dat", c, bg) w lp t sprintf("c=%s, bg=%s", c, bg)
