lr(n, g)=sprintf("c1.44e2-temp0.0001-gamma1.00-eta8.0-background0.00-nx30-n%s-ktypelaguerrewendland4eps-grid%s/prints/error_all.dat", n, g)

rdf(n, g)=sprintf("<tail -n 50 c1.44e2-temp0.0001-gamma1.00-eta8.0-background0.00-nx30-n%s-ktypelaguerrewendland4eps-grid%s/lrdf.dat", n, g)

set term x11 1
set log y
plot [:] \
     lr("3.50e+00", "0") w lp, \
     lr("3.72e+00", "0") w lp, \
     lr("3.94e+00", "0") w lp, \
     lr("4.17e+00", "0") w lp, \
     lr("4.39e+00", "0") w lp, \
     lr("4.61e+00", "0") w lp, \
     lr("4.83e+00", "0") w lp, \
     lr("5.06e+00", "0") w lp
     
unset log y
     
set term x11 2
plot \
     rdf("3.50e+00", "0") u 2:3 w lp,\
     rdf("3.72e+00", "0") u 2:3 w lp,\
     rdf("3.94e+00", "0") u 2:3 w lp,\
     rdf("4.17e+00", "0") u 2:3 w lp,\
     rdf("4.39e+00", "0") u 2:3 w lp,\
     rdf("4.61e+00", "0") u 2:3 w lp,\
     rdf("4.83e+00", "0") u 2:3 w lp,\
     rdf("5.06e+00", "0") u 2:3 w lp