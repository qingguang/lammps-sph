set key center
set term x11 1
set title "n=4.0, wendland6, c5e2"
plot  [:] \
      "<sort -k 1 -g c5e2-ndim2-eta8.0-sdpd_background0.0-nx30-n4.0-ktypewendland6/dump00006000.dat.smothed" u 1:4 w l t "exact", \
      "" u 1:3 t "smothed" w l, \
      "" u 1:5 t "SPH"

set title "n=6.0, laguerregaussian, c=5e2"
set term x11 2
plot  [:] \
      "<sort -k 1 -g c5e2-ndim2-eta8.0-sdpd_background0.0-nx30-n4.0/dump00006000.dat.smothed" u 1:4 w l t "exact", \
      "" u 1:3 t "smothed" w l, \
      "" u 1:5 t "SPH"

set title "n=6.0, wendland6, c=5e2"
set term x11 3
plot  [:] \
      "<sort -k 1 -g c5e2-ndim2-eta8.0-sdpd_background0.0-nx30-n6.0-ktypewendland6/dump00006000.dat.smothed" u 1:4 w l t "exact", \
      "" u 1:3 t "smothed" w l, \
      "" u 1:5 t "SPH"
      
set title "n=6.0, laguerregaussian, c=5e2"
set term x11 4
plot  [:] \
      "<sort -k 1 -g c5e2-ndim2-eta8.0-sdpd_background0.0-nx30-n6.0-ktypelaguerregaussian/dump00006000.dat.smothed" u 1:4 w l t "exact", \
      "" u 1:3 t "smothed" w l, \
      "" u 1:5 t "SPH"

set title "n=6.0, laguerregaussian, c=1e3"
set term x11 5
plot  [:] \
      "<sort -k 1 -g c1e3-ndim2-eta8.0-sdpd_background0.0-nx30-n6.0-ktypelaguerregaussian/dump00006000.dat.smothed" u 1:4 w l t "exact", \
      "" u 1:3 t "smothed" w l, \
      "" u 1:5 t "SPH"
      
      