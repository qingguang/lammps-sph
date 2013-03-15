# gnuplot script to fit autocorrelation data
f(x) = exp(-x/tau)

tlim=30
fit [0:tlim] f(x) "corr.dat" via tau
plot "corr.dat", f(x)
