plot "rg20.cum" w l t system("date"), \
     "rg30.cum" u ($1*(20.0/30.0)**0.500) w l t "0.500", \
     "rg30.cum" u ($1*(20.0/30.0)**0.588) w l t "0.588", \
     "rg30.cum" u ($1*(20.0/30.0)**0.620) w l t "0.620", \
     "rg30.cum" u ($1*(20.0/30.0)**0.750) w l t "0.750"

call "saver.gp" "tmp"

f(x) = a*x + b
fit [-0.3:0.3] f(x) "<seq -2 0.3 3 | awk '{print exp($1)}' | getst -l  punto30.dat" via a, b     
plot [][] \
     "<seq -2 0.3 3 | awk '{print exp($1)}' | getst -l  punto30.dat" w lp, \
     "<seq -2 0.3 3 | awk '{print exp($1)}' | getst -l punto20.dat"  w lp, \
     f(x) t sprintf("mu = %5.3f", -1/a)
     
call "saver.gp" "st"
