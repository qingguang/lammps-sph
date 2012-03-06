# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**2
tau=2

fit  f(x) "< head -5 spectra.dat" via c1,tau
fit  t(x) "< head -5 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
plot "spectra.dat"title "Ek-k in 3D polymer", f(x) title "Best-Fit Curve",t(x) title "theory Ek~k^2"
print "the tau is:", tau
