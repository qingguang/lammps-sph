#!/bin/bash

grid=$1
for d in $(ls -d c*grid${grid}*); do
    n=$(echo $d | awk -v RS="-" '$1~"^n[0-9]"{gsub("n", ""); print}')
    f=$(ls -1 ${d}/dump*.dat  | tail -n1)
    finput="\"${f}\""
    ktype=laguerrewendland4eps
    
    err=$(awk '$1>0.8{print $2; exit}' ${d}/prints/error_all.dat)
    echo ${n} ${err}
done



