# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**tau
<<<<<<< HEAD
c=1e-3
#c1=1
tau=-0.5
=======
c=3e7
#c1=1
tau=-2.3
>>>>>>> 4c9841d2424360dbd4c4f2b5f5655aa2583abb79
tlim=3
#fit  f(x) "<tail -14 spectra.dat" via c1
#fit  t(x) "<head -8 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
set key right
<<<<<<< HEAD
plot "spectra.dat" title "2D solvent 64*64 Re~0.02 sph",\
 t(x) title "Ek~k^0", "spectra2.dat","spectra4.dat","spectra7.dat","spectra8.dat","spectra24.dat"
=======
plot "spectra.dat" title "2D solvent 64*64 Re~0.02 T1e11",\
 t(x) title "Ek~k^0"
>>>>>>> 4c9841d2424360dbd4c4f2b5f5655aa2583abb79
#plot "spectra.dat"title "Ek-k in 3D polymer Kolmogorov Re=0.87 Wi=2.6", f(x) title "Best-Fit Ek~k^1.54"

#plot "spectra.dat"title "Ek-k in 3D polymer deform Re=1 Wi~260",f(x) title "Fit Curve Tail part Ek~k^-3.1",t(x) title "Fit Curve Ek~k^-2.5"

print "the tau is:", tau
