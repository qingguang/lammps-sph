#! /bin/bash
../script/lammps2punto.sh data/dump*.*  | awk 'NF{print $3, $4, $9, $10, $NF} !NF' > hm
