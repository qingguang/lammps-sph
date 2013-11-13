set xlabel "time step"
set ylabel "displacement"
plot [0:20000] \
     "<awk -f disp.awk c3e2-ndim2-eta25.0-sdpd_background0.0n/swimmercom.dat" u (sqrt($1**2+$2**2)) w l, \
     "<awk -f disp.awk c3e2-ndim2-eta25.0-sdpd_background0.0np/swimmercom.dat" u (sqrt($1**2+$2**2)) w l