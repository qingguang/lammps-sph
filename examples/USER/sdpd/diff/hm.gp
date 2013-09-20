d="c4.64e+01-ndim2-eta8.0-sdpd_background0.0-nx30-n5.60e+00-ktypelaguerrewendland4"

lr(d)=sprintf("<tail -n50 %s/lrdf.dat", d)

plot lr(d) u 2:3