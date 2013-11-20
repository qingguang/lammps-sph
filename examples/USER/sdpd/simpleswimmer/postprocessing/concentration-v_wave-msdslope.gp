f(c)=sprintf("<awk '$1==%s{print $2, $3}' concentration-v_wave-msdslope.dat | sort -g", c)

set macros
set log x
m='($1):($2*(c+0.4))
set term x11 1
plot c="0", f(c) u @m w lp, \
     c="0.333037", f(c) u @m w lp, \
     c="0.666518", f(c) u @m w lp, \
     c="1", f(c) u @m w lp

m='($1):($2)'
set term x11 2
plot c="0", f(c) u @m w lp, \
     c="0.333037", f(c) u @m w lp, \
     c="0.666518", f(c) u @m w lp, \
     c="1", f(c) u @m w lp
     
