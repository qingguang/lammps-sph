# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**2
tau=2

fit  f(x) "< head -5 spectra.dat" via c1,tau
fit  t(x) "< head -5 spectra.dat" via c
set log xy
plot "spectra.dat"title "Ek-k", f(x) title "Best-Fit Curve",t(x) title "theory"
print "the tau is:", tau
