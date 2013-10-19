f(c, n, k)=sprintf("c%s-ndim2-eta1.00e+00-sdpd_background0.0-nx30-n%s-ktype%s/dump00010000.dat", c, n, k)
r(c, n, k)=sprintf("<tail -n 50 c%s-ndim2-eta1.00e+00-sdpd_background0.0-nx30-n%s-ktype%s/lrdf.dat", c, n, k)

n="5.00e+00"
c="1.00e+01"

set term x11 1
plot f(c, n, "wendland4") u 3:10, "" u 3:11

set term x11 2
plot f(c, n, "laguerre2wendland2eps") u 3:10, "" u 3:11

set term x11 3
plot f(c, n, "laguerre2wendland4eps") u 3:10, "" u 3:11

set term x11 4
plot f(c, n, "laguerrewendland4eps") u 3:10, "" u 3:11

set term x11 5
plot r(c, n, "wendland4") u 2:3 w l, \
     r(c, n, "laguerrewendland4") u 2:3 w l, \
     r(c, n, "laguerre2wendland4eps") u 2:3 w l, \
     r(c, n, "laguerrewendland4eps") u 2:3 w l     

#     plot "<awk 's{print $9} /ITEM: ATOMS/{s=1}' c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/dump00040000.dat | gsl-histogram 0.9 1.0 100" u 2:3 w lp