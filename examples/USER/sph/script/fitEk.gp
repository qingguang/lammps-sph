# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**(2)
tau=2
tlim=3
#fit  f(x) "<tail -8 spectra.dat" via c1,tau
fit  t(x) "<tail -16 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
plot "spectra.dat"title "Ek-k in 3D solvent Kolmogorov Re=1", t(x) title "theory Ek~k^2"
#plot "spectra.dat"title "Ek-k in 3D kolmogorov polymer",f(x) title "Best-Fit Curve Ek~k^1.74",t(x) title "theory Ek~k^2"
print "the tau is:", tau
