#! /bin/bash

set -e
set -u
id=$1

# transform lammps dump files into punto format
awk -v id=${id} '(NR>1)&&(FNR==1){printf "\n"; f=0} f&&$1==id{print $3, $4, $5}; /ITEM: ATOMS/{f=1}' $* 
