# reset
# set view map

# set xlabel "x"
# set ylabel "y"

# load "palette"
# 

#set term x11 1
#splot "fene-nb2-ns4-nx20-H0.2-bg0.0/stress.hist" u 1:2:($5+$4)*k w p palette pt 5 ps 1.93

#set term x11 2
#splot "fene-nb2-ns4-nx64-H0.2-bg1.0/stress.hist" u 1:2:($4)*k w p palette pt 5 ps 1.90

file(Lx, dname)=sprintf("<awk -v Lx=%e '$2>0.49*Lx&&$2<0.51*Lx' %s/stress.hist", Lx, dname)

k=1e6
Lx=0.0533333
plot [0:1] file(Lx, "fene-nb2-ns4-nx64-H0.2-bg1.0") u ($1/Lx):($4)*k w lp

call "saver.gp" stress
