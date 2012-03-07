p=1.0
vc=0.04
vp=vc
H=0.5
set macros
file="<./lastvav.sh vxsol.av"
file_with_u="file u 2:(-$4)"

v2p(x)= vp*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/1.0))
v(x)= vc*(1 - (abs(x-H/2.0)/(H/2.0))**(1.0+1.0/p))

fit [0:H] v2p(x) @file_with_u  via vp

vc=vp
fit [0:H] v(x) @file_with_u via vc, p

plot [0:H] \
     v2p(x) t "newtonian", \
     v(x) t sprintf("p=%f", p), \
     @file_with_u t "SDPD"