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

dname=fene-nb25-ns25-nx1024-H300-next5
dscript=${lmpdir}/examples/USER/sph/script

bash ${dscript}/lammps2punto.sh ${dname}/stress* > ${dname}/stress.dat
bash ${dscript}/lammps2punto.sh ${dname}/dump* > ${dname}/punto.dat
awk -v Lx=$(getLx) -v Ly=$(getLy) -f ${dscript}/sphap.awk ${dname}/stress.dat  > ${dname}/stress.hist
awk -v xidx=3 -v yidx=4 -v Lx=$(getLx) -v Ly=$(getLy) -f ${dscript}/sphap.awk ${dname}/punto.dat  > ${dname}/vel.hist

gnuplot stress.gp
cp stress.png ~/Dropbox/

