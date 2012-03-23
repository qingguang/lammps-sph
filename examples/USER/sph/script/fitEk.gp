# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**(2)
tau=2
tlim=3
fit  f(x) "<tail -14 spectra.dat" via c1,tau
fit  t(x) "<tail -14 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
#plot "spectra.dat"title "Ek-k in 3D solvent Kolmogorov Re=1", t(x) title "fit Ek~k^1.5128"
#plot "spectra.dat"title "Ek-k in 3D solvent Kolmogorov Re=1", f(x) title "fit Ek~k^1.5128"

plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6",f(x) title "Best-Fit Curve Ek~k^1.94",t(x) title "theory Ek~k^2"

print "the tau is:", tau
