# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**tau
c=10
c1=1
tau=1
tlim=3
#fit  f(x) "<tail -14 spectra.dat" via c1
fit  t(x) "<tail -12 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
set key right
plot "spectra.dat"title "Simulation Polymer", t(x) title "Ek~k^1"
#plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

#plot "spectra.dat"title "Ek-k in 3D polymer deform Re=1 Wi~260",f(x) title "Fit Curve Tail part Ek~k^-3.1",t(x) title "Fit Curve Ek~k^-2.5"

print "the tau is:", tau
