# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**(2)
tau=2
tlim=3
fit  f(x) "<tail -8 spectra.dat" via c1,tau
fit  t(x) "<tail -14 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
plot "spectra.dat"title "Ek-k in 3D solvent Kolmogorov Re=47 L=2PI", t(x) title "Best-Fit Ek~k^2"
#plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

#plot "spectra.dat"title "Ek-k in 3D solvent Kolmogorov Re=1",f(x) title "Best-Fit Curve Ek~k^1.26",t(x) title "theory Ek~k^2"

print "the tau is:", tau
