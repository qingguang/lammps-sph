set style data lp
set log

plot [1e-7:10][1e-4:1.0] \
     "c4.20-temp0.00-gamma1.00-eta1.00-background0.00-nx30-n3.00-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2 w lp, \
     "c4.20-temp0.00-gamma1.00-eta0.40-background0.00-nx35-n3.50-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2, \
     "c4.20-temp0.00-gamma1.00-eta0.18-background0.00-nx40-n4.00-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2, \
     "c4.20-temp0.00-gamma1.00-eta0.09-background0.00-nx45-n4.50-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2, \
     "c4.20-temp0.00-gamma1.00-eta0.05-background0.00-nx50-n5.00-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2, \
     "c4.20-temp0.00-gamma1.00-eta0.03-background0.00-nx55-n5.50-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2, \
     "c4.20-temp0.00-gamma1.00-eta0.02-background0.00-nx60-n6.00-ktypewendland6-grid0-beta/prints/error_all.dat" u 3:2