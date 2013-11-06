#! /bin/bash

set -e
set -u
# transform lammps dump files into punto format
awk '(NR>1)&&(FNR==1){printf "\n"; f=0} f{print $3, $4, $5}; /ITEM: ATOMS/{f=1}' $* 
