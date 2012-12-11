p=1.0
vc=0.04
vp=vc
vc2=0.04
vp2=vc2
vc5=0.04
vp5=vc5
H=0.5
set macros
set key left
file25="<./lastvav.sh vx25beads502-2L.av"
file25_with_u="file25 u 2:(-$4)"

v2p25(x)= vp25*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/1.0))
v25(x)= vc25*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/p25))

fit [0:H] v2p25(x) @file25_with_u  via vp25

vc25=vp25
fit [0:H] v25(x) @file25_with_u via vc25, p25

file5="<./lastvav.sh vx5beads511-2L.av"
file5_with_u="file5 u 2:(-$4)"

v2p(x)= vp5*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/1.0))
v(x)= vc5*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/p5))

fit [0:H] v2p(x) @file5_with_u  via vp5

vc5=vp5
fit [0:H] v(x) @file5_with_u via vc5, p5

file2="<./lastvav.sh vx2beads522-2L.av"
file2_with_u="file2 u 2:(-$4)"

v2p2(x)= vp2*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/1.0))
v2(x)= vc2*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/p2))

fit [0:H] v2p2(x) @file2_with_u  via vp2

vc2=vp2
fit [0:H] v2(x) @file2_with_u via vc2, p2

files="<./lastvav.sh vxsol.av"
files_with_u="files u 2:(-$4)"

v2ps(x)= vp*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/1.0))
vs(x)= vc*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/p))

fit [0:H] v2ps(x) @files_with_u  via vp

vc=vp
fit [0:H] vs(x) @files_with_u via vc, p
#set term postscript eps enhanced
set label "Solvent" at 0.14,0.045
set label "N=2" at 0.14,0.033
set label "N=5" at 0.16,0.029
set label "N=25" at 0.14,0.023
set style line 1 lt -1 lw 1
set style line 2 lt 2 lw 2
plot [0:H/2] \
     v2p(x) t "parabolic,p=1" w l ls 1, \
     v(x) t "power law" w l ls 2, \
     @file5_with_u t "SDPD" w p pt 6 lt 1, \
v2p2(x) t "" w l ls 1, \
     v2(x) t "" w l ls 2, \
     @file2_with_u t "" w p pt 6 lt 1,\
v2ps(x) t "" w l ls 1, \
     vs(x) t "" w l ls 2, \
     @files_with_u t "" w p pt 6 lt 1, \
v2p25(x) t "" w l ls 1, \
     v25(x) t "" w l ls 2, \
     @file25_with_u t "" w p pt 6 lt 1

