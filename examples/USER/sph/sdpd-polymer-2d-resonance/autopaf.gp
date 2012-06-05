
#set log xy
#plot 'rcom.dat' u 1:2
#plot 'rcom.dat' u ($1)*5.2083333e-6*1e3:2  w lp
#plot './rcom.dat' u ($1)*6.25e-3:2,'./rcom.dat' \
#u ($1)*6.25e-3:((-(($1)*6.25e-3)+1.8)**(3/2))/1.8 w lp
f(x) = c1*x
fit  f(x) "Msd.dat" via c1
#plot './Msd.dat' u ($1)*5.02e-4:2,'./rcom.dat' \
#u ($1)*5.02e-4:($1)*5.02e-4*0.0099,f(x) w lp
plot './Msd.dat' u ($1)*6.25e-03:2,f(x)/6.25e-03 w lp
print c1/6.25e-03/4;

