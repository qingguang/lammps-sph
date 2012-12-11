set key left
set label "high shear rate" at 0.0015,3e-5
set yrange [-1e-3:2e-3]
#set mxtics 5
#set mytics 5
#set format x "%.1g"
plot '<tail -15 pdataR49/poly.1' u 2:1 title "high shear rate"  w lp, \
'<tail -15 pdataR4.9/poly.1' u 1:2 title "low shear rate" w lp, \
'<tail -15 pdata/poly.50' u 1:2 title "very low shear rate" w lp 
