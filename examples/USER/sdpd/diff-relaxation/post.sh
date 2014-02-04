#!/bin/bash

for dname in $(find . -type d -name 'c*'); do
    dlast=$(ls -1 ${dname}/dump*.dat  | tail -n1)
    n=$(echo ${dname} | awk -v FS="-" '{print $NF}' | tr -d n)
    err=$(awk 'NF==12{s+=$12; n++} END {print s/n}' ${dlast})
    echo ${n} ${err}
    ./lammps2punto.sh ${dname}/dump*.dat > ${dname}/punto.dat
    tac ${dname}/punto.dat | awk '!NF{s=1} !s{$3=int(32*rand()); print}' > ${dname}/pattern.txt
done
