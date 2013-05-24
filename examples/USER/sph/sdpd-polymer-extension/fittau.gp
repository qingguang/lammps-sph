# gnuplot script to fit autocorrelation data
f(x) = a*exp(-x/tau)+b
a=0.5
b=0.2
tau=100
#tlim=10
fit  f(x) "extension_32.dat" u ($1*2.08333325e-05):2  via tau,a,b
plot "extension_32.dat" u ($1*2.08333325e-05):2, f(x)
print 'tau is:',tau
print 'a is:', a
print 'b is:', b

