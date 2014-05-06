pfile_aux(d)=sprintf("<paste %s/prints/moments_all.dat %s/prints/error_all.dat", d, d)
pfile(d0)=pfile_aux(sprintf(d0, k))

set size 0.75
set key left maxrows 3
set xlabel "max(|F|)"
set ylabel "L_1"
ftitle(n)=sprintf("N_k = %.2f", n+0.0)

tr=3e-5
set arrow from tr,1e-4 to tr,0.1 nohead
set log
#k="wendland6"
k="laguerrewendland4eps"
plot [][1e-4:1] \
     n="3.00", c="4.22", pfile("c4.22-temp0.00-gamma1.00-eta1.0-background0.00-nx30-n3.00-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="3.50", c="6.70", pfile("c6.70-temp0.00-gamma1.00-eta1.0-background0.00-nx35-n3.50-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="4.00", c="10.00", pfile("c10.00-temp0.00-gamma1.00-eta1.0-background0.00-nx40-n4.00-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="4.50", c="14.24", pfile("c14.24-temp0.00-gamma1.00-eta1.0-background0.00-nx45-n4.50-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="5.00", c="19.53", pfile("c19.53-temp0.00-gamma1.00-eta1.0-background0.00-nx50-n5.00-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="5.50", c="26.00", pfile("c26.00-temp0.00-gamma1.00-eta1.0-background0.00-nx55-n5.50-ktype%s-grid0-lambda") u 13:15 t ftitle(n), \
     n="6.00", c="33.75", pfile("c33.75-temp0.00-gamma1.00-eta1.0-background0.00-nx60-n6.00-ktype%s-grid0-lambda") u 13:15 t ftitle(n)

call "saver.gp" "errorvsres" 
     
