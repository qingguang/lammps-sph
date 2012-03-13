# gnuplot script to fit autocorrelation data
f(x) = 584*exp(-x/tau)

tlim=100
fit [0:tlim] f(x) "corfun.dat" via tau
plot "corfun.dat", f(x)
print 'tau is:',tau
