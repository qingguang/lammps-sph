file(Lx, dname)=sprintf("<awk -v Lx=%e '$2>0.49*Lx&&$2<0.51*Lx' %s/vel.hist", Lx, dname)

set key bottom

Lx=0.0533333
l_units = .008488263292037206
vel_units = 1.178097292220064
Wi = 17.0

set xlabel "x"
set ylabel "v_x"

plot [0:2*pi] file(Lx, "fene-nb2-ns4-nx64-H0.2-bg1.0") u ($1/l_units):($6/vel_units) w lp t "", \
     1/Wi*(x-pi) * 1.0/(x<1.2*pi) * 1.0/(x>0.8*pi) w l lw 3 t sprintf("Wi=%.2f", Wi)


call "saver.gp" "vel-nx64-nb2"


Lx=0.0533333*2.0
l_units = .01697652658407441
vel_units = 0.589048646110032
Wi = 17/2.0

plot [0:2*pi] file(Lx, "fene-nb2-ns4-nx128-H0.2-bg1.0") u ($1/l_units):($6/vel_units) w lp t "", \
     1/Wi*(x-pi) * 1.0/(x<1.2*pi) * 1.0/(x>0.8*pi) w l lw 3 t sprintf("Wi=%.2f", Wi)

call "saver.gp" "vel-nx128-nb2"
