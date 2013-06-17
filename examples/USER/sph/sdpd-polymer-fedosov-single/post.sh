#! /bin/bash

nskip=150
for nb in 20 30; do
    awk --lint=fatal -v L=10.0 -f ../scripts/xyz2punto.awk  b10-nb${nb}/poly3d.xyz | \
	awk -v ns=${nskip} 'f>ns; NF==0{f++}' > punto${nb}.dat 
    ~/google-svn/awk/polymer/polycm.awk punto${nb}.dat > punto${nb}.cm
    getrg --rg punto${nb}.dat | awk '{s+=$1; n++; print s/n}' > rg${nb}.cum
done

