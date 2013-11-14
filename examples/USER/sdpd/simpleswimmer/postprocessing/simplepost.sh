#!/bin/bash

cuttime=30
for f in $(find ../supermuc-data/ -name moments_swimmercom.dat); do
    d=$(dirname $f)
    awk --lint=fatal -v cuttime=${cuttime} '$1>cuttime{print $1-cuttime}' $f > ${d}/msd.dat.time
    awk --lint=fatal -v cuttime=${cuttime} '$1>cuttime{print $2, $3, $4}' $f | msd -f "/dev/stdin" >  ${d}/msd.dat.aux
    paste ${d}/msd.dat.time ${d}/msd.dat.aux > ${d}/msd.dat
    rm ${d}/msd.dat.time ${d}/msd.dat.aux
    echo ${d}/msd.dat
done


