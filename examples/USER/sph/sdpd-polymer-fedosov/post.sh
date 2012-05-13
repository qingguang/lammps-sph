#! /bin/bash
rm -rf punto.dat
rm -rf pdata
awk 'fl{print $3, $4, $5, $6,$7,$8} /ITEM: ATOMS/{fl=1}' dumpreal*.dat > punto.dat
awk -f extpolymer.awk dumpreal*.dat
#octave -q --eval "ext"

