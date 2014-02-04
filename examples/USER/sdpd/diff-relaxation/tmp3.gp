f(c, n, k)=sprintf("<awk 's; /ITEM: ATOMS/{s=1}' c%s-ndim2-eta1.00e+00-sdpd_background0.0-nx30-n%s-ktype%s/dump00010000.dat | sort -g -k 2", c, n, k)
r(c, n, k)=sprintf("<tail -n 50 c%s-ndim2-eta1.00e+00-sdpd_background0.0-nx30-n%s-ktype%s/lrdf.dat", c, n, k)

n="5.00e+00"
c="1.00e+01"
set term postscript eps enhanced color
fi="~/img/n".n
set output fi

set macro
set multiplot layout 2,2 rowsfirst

set xlabel "x"
set ylabel "dv"
k="wendland4"
plot f(c, n, k) u 3:10 w l t k, "" u 3:11 w l t "exact"

k="laguerre2wendland2eps"
plot f(c, n, k) u 3:10 t k, "" u 3:11 w l t "exact"

k="laguerre2wendland4eps"
plot f(c, n, k) u 3:10 t k, "" u 3:11 w l t "exact"

k="laguerrewendland4eps"
plot f(c, n, k) u 3:10  t k, "" u 3:11 w l t "exact"

unset multiplot