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

nproc=8
ndim=3d
Nbeads=25
Nsolvent=0
dname=fene-nb${Nbeads}

vars="-var ndim ${ndim} -var dname ${dname}"

#rm poly*
${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} poly3d.restart poly3d.txt


 awk -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=1 \
     -f addpolymer.awk poly3d.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt

# output directory name

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
