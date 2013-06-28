awk 'NF{print $2}' pdata/poly.* | gsl-histogram 0 1.803e-3 48 > bead-hist.dat
