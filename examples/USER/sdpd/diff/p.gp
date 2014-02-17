f(n)= \
sprintf(\
"<awk -f lpeak.awk c1.44e2-temp0.0001-gamma1.00-eta8.0-background0.00-nx30-n%se+00-ktypelaguerrewendland4eps-grid0/lrdf.dat",\
n)

set style data l
plot \
     f("3.94"), \
     f("4.17"), \
     f("4.39"), \
     f("4.61"), \
     f("4.83"), \
     f("5.06"), \
     f("5.28"), \
     f("5.50")

