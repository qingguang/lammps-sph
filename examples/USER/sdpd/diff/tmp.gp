c="1.62e+01"
#kt="laguerrewendland4eps"
kt="laguerre2wendland4eps"
#kt="wendland4"
f="c".c."-ndim2-eta1.0-sdpd_background0.0-nx30-n3.00e+00-ktype".kt

set term x11 1
plot f."/dump00008000.dat" u 3:10, "" u 3:11

set term x11 2
plot "<tail -n 50 ".f."/lrdf.dat" u 2:3 w l

set term x11 3
plot f."/dump00008000.dat" u 3:4

set term x11 4
plot f."/dump00008000.dat" u 3:9
