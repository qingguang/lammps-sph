#!/bin/bash

for dname in $(find . -type d -name 'c*lambda'); do
    lfile=${dname}/log.lammps
    echo ${dname}
    grep Lx ${lfile} | awk 'NR==2{print $4}'
done
