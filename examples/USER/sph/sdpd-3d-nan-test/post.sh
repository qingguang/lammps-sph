#! /bin/bash
rm -rf punto.dat
awk 'fl{print $3, $4, $5, $6, $7, $8} /ITEM: ATOMS/{fl=1} FNR==1{fl=0}' dump*.dat > punto.dat
