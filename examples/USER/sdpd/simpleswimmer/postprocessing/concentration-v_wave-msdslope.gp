f(c)=sprintf("<awk '$1==%s{print $2, $3}' concentration-v_wave-msdslope.dat | sort -g", c)

set macros
set log x
set xlabel "Driving frequency"
set ylabel "Average swimming speed"

mtitle(c)=sprintf("c_p = %4.0f\%", c*100)

L=10.0
m='($1/L):($2)'
set term x11 2
set key left
plot [][:0.50]\
     c="0", f(c) u @m w lp lw 3 t "Newtonian", \
     c="0.333037", f(c) u @m w lp lw 3 t "Low concentration", \
     c="0.666518", f(c) u @m w lp lw 3 t "Intermediate concentration", \
     c="1", f(c) u @m w lp lw 3 t "High concentration"
     
call "saver.gp" "concentration-v_wave-msdslope"