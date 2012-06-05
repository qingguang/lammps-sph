# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=6e5*x**(-2.5)
c1=1
tau=2
tlim=3
fit  f(x) "<tail spectra.dat" via c1,tau
#fit  t(x) "<head -5 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
#plot "spectra.dat"title "Ek-k in 3D solvent deform  Re=10", t(x) title "Best-Fit Ek~k^-2.5"
plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

#plot "spectra.dat"title "Ek-k in 3D polymer deform Re=10 Wi=26",f(x) title "Best-Fit Curve Ek~k^-2.5",t(x) title "theory Ek~k^2"

print "the tau is:", tau
