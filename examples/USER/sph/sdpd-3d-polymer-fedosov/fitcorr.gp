# gnuplot script to fit autocorrelation data
f(x) = vm*(1-(x/0.125)**(1+1/p))
vm=0.04;
p=1;

fit f(x) "<./lastvav.sh vx2beads1000.av" using 2:4 via vm,p
#set xrange [0:0.25]
plot "vx.av", f(x)
