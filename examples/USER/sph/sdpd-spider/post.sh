#! /bin/bash

function getLx() {
    awk 'f{print $2; exit} /ITEM: BOX BOUNDS/{f=1} ' ${dname}/stress00000000.dat 
}

function getLy() {
    awk 'f==1{f++; next} f==2{print $2; exit} /ITEM: BOX BOUNDS/{f=1} ' ${dname}/stress00000000.dat 
}


set -e
set -u
source ${HOME}/lammps-sph-nana.sh

dname=fene-nb2-ns4-nx20
dscript=${lmpdir}/examples/USER/sph/script

for dname in fene-nb5-ns5-nx256-H0.2-bg1.0/ ; do
    bash ${dscript}/lammps2punto.sh ${dname}/stress* > ${dname}/stress.dat
    bash ${dscript}/lammps2punto.sh ${dname}/dump* > ${dname}/punto.dat
    awk -v Lx=$(getLx) -v Ly=$(getLy) -f ${dscript}/sphap.awk ${dname}/stress.dat  > ${dname}/stress.hist
    awk -v xidx=3 -v yidx=4 -v Lx=$(getLx) -v Ly=$(getLy) -f ${dscript}/sphap.awk ${dname}/punto.dat  > ${dname}/vel.hist
done

gnuplot stress.gp
cp stress.png ~/Dropbox/

