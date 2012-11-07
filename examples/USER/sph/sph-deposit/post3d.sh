#! /bin/bash
# x, y, fx, fy, colorgradient_peratom
dname=data-wall/
../script/lammps2punto.sh ${dname}/dump*.*  | awk 'NF{print $3, $4, $5, $9, $10, $11, $2, $12, $NF} !NF' > hm
../script/lammps2punto.sh ${dname}/dump*.*  | awk 'NF&&$2==2{print $3, $4, $5, $9, $10, $11, $2, $12, $NF} !NF' | awk 'NR>1' > sp

