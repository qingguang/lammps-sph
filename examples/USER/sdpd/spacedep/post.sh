#! /bin/bash

for d in $(ls -d c*); do
    ./lammps2punto.sh ${d}/dump*.dat > ${d}/punto.dat
done
