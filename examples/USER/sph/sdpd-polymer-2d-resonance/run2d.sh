#! /bin/bash

set -e
set -u
configfile=$HOME/lammps-sph.sh
if [ -f "${configfile}" ]; then
    source "${configfile}"
else
    printf "cannot find config file: %s\n" ${configfile} > "/dev/stderr"
    exit -1
fi
nproc=2
ndim=2d

rm -rf dum* im* vx.av log* poly*
${lmp} -in sdpd-polymer-inti.lmp
${restart2data} poly2d.restart poly2d.txt


 awk -v cutoff=3.0 -v Nbeads=32 -v Nsolvent=4064 -v Npoly=full \
     -f addpolymer.awk poly2d.txt > poly2.txt
 nbound=$(tail -n 1 poly2.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly2.txt > poly2d.txt

${mpirun} -np ${nproc} ${lmp} -var ndim ${ndim} -in sdpd-polymer-run.lmp

