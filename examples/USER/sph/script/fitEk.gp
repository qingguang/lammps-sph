# gnuplot script to fit autocorrelation data
f(x) = c1*x**tau
t(x)=c*x**tau
c1=2e9
tau=-3.8
tlim=3
#fit  f(x) "spectra_new.dat" u 1:2 via c1,tau
#fit  t(x) "<head -8 spectra.dat" via c
set logscale
set xlabel "k"
set ylabel "Ek"
set key right
#plot "spectra0.dat" title "2D solvent 64*64 ",\
# t(x) title "Ek~k^-1.8", "spectra1.dat", "spectra2.dat","spectra3.dat",\
#"spectra4.dat", "spectra5.dat"
set multiplot
plot "spectra.dat" title "Ek-k in 2d polymer roller" , f(x) title "Best-Fit Ek~k^-3.8"
unset multiplot
#plot "spectra.dat"title "Ek-k in 3D polymer deform Re=1 Wi~260",f(x) title "Fit Curve Tail part Ek~k^-3.1",t(x) title "Fit Curve Ek~k^-2.5"

print "the tau is:", tau
set terminal png
set output sprintf("%s.png", "Ek-polymer-roller-chaotic")
replot

