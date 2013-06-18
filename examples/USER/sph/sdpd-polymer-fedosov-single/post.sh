#! /bin/bash

nskip=2000
for nb in 20; do
    dname=b10-nb${nb}
    L=$(awk 's{print $2; exit} /ITEM: BOX/{s=1}' ${dname}/dump00000000.dat)
    awk --lint=fatal -v L=${L} -f ../scripts/xyz2punto.awk  ${dname}/poly3d.xyz | \
	awk -v ns=${nskip} 'f>ns; NF==0{f++}' > punto${nb}.dat 
    ~/google-svn/awk/polymer/polycm.awk punto${nb}.dat > punto${nb}.cm
    getrg --rg punto${nb}.dat | awk '{s+=$1; n++; print s/n}' > rg${nb}.cum
    seq -1 0.01 1 | awk '{print 10**($1)}' | getst -l punto${nb}.cm > st${nb}.dat
done

