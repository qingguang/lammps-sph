# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=2e-2*x**(2)
tau=-3.1
tlim=3
fit  f(x) "<tail -4 spectra.dat" via c1
#fit  t(x) "<tail -5 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
#plot "spectra.dat"title "Ek-k in 3D solvent deform  Re=10", t(x) title "Best-Fit Ek~k^-2.5"
#plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

plot "spectra.dat"title "Ek-k in 3D polymer deform Re=1 Wi~260",f(x) title "Fit Curve Tail part Ek~k^-3.1",t(x) title "Fit Curve Ek~k^-2.5"

print "the tau is:", tau
