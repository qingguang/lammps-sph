dx=1.0/30.0
R(V) = (3.0/(4.0*pi))**(0.33333)*V**(0.3333)*dx - dx

A = 1
m = 1
f(x) = A*x**m
fit f(x) "vgy.3d.dat" u 1:(R($2)) via m, A

set term x11 1
set xlabel "g"
set ylabel "R"
plot "vgy.3d.dat" u 1:(R($2)) w p pt 7 ps 3, f(x)

set term x11 2
set xlabel "1/g"
set ylabel "R^2"
plot "vgy.3d.dat" u (1/$1):(R($2)**2) w p pt 7 ps 3, f(1/x)**2