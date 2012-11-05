# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**tau
c=1e1
#c1=1
tau=-1.8
tlim=3
#fit  f(x) "<tail -14 spectra.dat" via c1
#fit  t(x) "<head -8 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
set key right
plot "spectra0.dat" title "2D solvent 64*64 ",\
 t(x) title "Ek~k^-1.8", "spectra1.dat", "spectra2.dat","spectra3.dat",\
"spectra4.dat", "spectra5.dat"
#plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

#plot "spectra.dat"title "Ek-k in 3D polymer deform Re=1 Wi~260",f(x) title "Fit Curve Tail part Ek~k^-3.1",t(x) title "Fit Curve Ek~k^-2.5"

print "the tau is:", tau
