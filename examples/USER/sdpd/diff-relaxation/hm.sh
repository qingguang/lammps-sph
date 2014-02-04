#!/bin/bash

dist=$1
ktype=$2
for n in 3.0 3.5 4.0 4.5 5.0 5.5 6.0; do
    if [ ${dist} = "grid" ]; then
	f=pconf/grid.dat.n${n}.ktype${ktype}.smoothd
    else
	f=c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/dump00040000.dat.n${n}.ktype${ktype}.smoothd
    fi
    l1=$(awk 'function abs(x) {if (x>0) return(x); else return(-x)} {s+=($6-$4)^2; n++} END {print sqrt(s/n)}' $f)
    s1=$(awk 'function abs(x) {if (x>0) return(x); else return(-x)} {s+=($6-$3)^2; n++} END {print sqrt(s/n)}' $f)
    r1=$(awk 'function abs(x) {if (x>0) return(x); else return(-x)} {s+=($7-1.0)^2; n++} END {print sqrt(s/n)}' $f)
    echo ${n} ${l1} ${s1} ${r1}
done
