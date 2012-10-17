#! /bin/bash
# x, y, fx, fy, colorgradient_peratom
../script/lammps2punto.sh data/dump*.*  | awk 'NF{print $3, $4, $5, $9, $10, $11, $2, $NF} !NF' > hm
../script/lammps2punto.sh data/dump*.*  | awk 'NF&&$2==2{print $3, $4, $5, $9, $10, $11, $2, $NF} !NF' > sp
../script/lammps2punto.sh data/dump*.*  | awk 'NF&&$2==2{print $3, $5, $4, $9, $11, $10, $2, $NF} !NF' > tp
