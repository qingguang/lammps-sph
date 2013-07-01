f = "<tac ${HOME}/google-svn/latex/diff-paper/gnuplot/plotdata/rdf-data | awk '!NF{exit} 1'"
bgline="0.00"
cline= system("awk -v OFS=' ' 'NR>5' c.dat")

set term x11 1
set key left
plot for [c in cline] for [bg in bgline] \
     sprintf("c%s-ndim3d-eta25.0-sdpd_background%s/all.msd", c, bg) w lp t sprintf("c=%s, bg=%s", c, bg), \
     1000.0*x*6.0/25.0

set term x11 2
set key right
plot [0:0.3] for [c in cline] for [bg in bgline] \
     sprintf("c%s-ndim3d-eta25.0-sdpd_background%s/rdf.dat", c, bg) w lp t sprintf("c=%s, bg=%s", c, bg), f w l     