#!/bin/bash

ktype=$1
for n in 3.0 3.5 4.0 4.5 5.0 5.5 6.0; do
    f=c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/dump00040000.dat.n${n}.ktype${ktype}.smoothd
    l1=$(awk 'function abs(x) {if (x>0) return(x); else return(-x)} {s+=abs($6-$4); n++} END {print s/n}' $f)
    r1=$(awk 'function abs(x) {if (x>0) return(x); else return(-x)} {s+=abs($7-1.0); n++} END {print s/n}' $f)
    echo $n ${l1} ${r1}
done
