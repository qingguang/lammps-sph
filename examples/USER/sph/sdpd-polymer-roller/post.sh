#! /bin/bash

function getLx() {
    awk 'f{print $2; exit} /ITEM: BOX BOUNDS/{f=1} ' ${dname}/stress00000000.dat 
}

for dname in fene-nb4*; do
    bash ../script/lammps2punto.sh ${dname}/stress* > ${dname}/stress.dat
    bash ../script/lammps2punto.sh ${dname}/dump* > ${dname}/punto.dat
    awk -v Lx=$(getLx) -v Ly=$(getLx) -f ../script/sphap.awk ${dname}/stress.dat  > ${dname}/stress.hist
    awk -v xidx=3 -v yidx=4 -v Lx=$(getLx) -v Ly=$(getLx) -f ../script/sphap.awk ${dname}/punto.dat  > ${dname}/vel.hist
done

gnuplot stress.gp
cp stress*.png ~/Dropbox/

