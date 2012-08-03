file(Lx, dname)=sprintf("<awk -v Lx=%e '$2>0.49*Lx&&$2<0.51*Lx' %s/stress.hist", Lx, dname)

k=1e6

Lx=0.0533333
plot [0:1] file(Lx, "fene-nb4-ns8-nx64-H0.2-bg1.0") u ($1/Lx):($4)*k w lp
call "saver.gp" "stress-nx64-nb4"


Lx=0.106667
plot [0:1] file(Lx, "fene-nb4-ns8-nx128-H0.2-bg1.0") u ($1/Lx):($4)*k w lp
call "saver.gp" "stress-nx128-nb4"
