#! /bin/bash
rm -rf punto.dat
rm -rf pdata
#awk 'fl{print $3, $4, $5, $6,$7,$8} /ITEM: ATOMS/{fl=1}' *.dat > punto.dat
awk -f extpolymer.awk dump*.dat
# write auto-correlation to corr.dat
#octave -q --eval ext
#gnuplot fitcorr.gp
