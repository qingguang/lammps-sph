set xlabel "y"
set ylabel "vx"
Lx=0.1
set key center
plot "<awk 'NF==4{print $2, $4}' data/vcen.av | sort -g" u ($1*Lx):2 t "cenerline", \
     "<awk 'NF==4{print $2, $4}' data/vend.av | sort -g" u ($1*Lx):2 t "end", \
     "morris-fig6-1" t "FEM" w l, \
     "morris-fig6-2" t "FEM" w l 

