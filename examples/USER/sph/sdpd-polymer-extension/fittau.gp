# gnuplot script to fit autocorrelation data
f(x) = a*exp(-x/tau)+b
a=0.6
b=0.2
tau=50
#tlim=10
fit  f(x) "< tail -50000 extenfree.dat" u ($1*8.680554861e-06):2  via tau,a,b
plot "< tail -50000 extenfree.dat" u ($1*8.680554861e-06):2 title "16-bead polymer", f(x)
print 'tau is:',tau
print 'a is:', a
print 'b is:', b
#set terminal png
#set output sprintf("%s.png", "fitting-16-bead-polymer-eta1e-2")
#replot
