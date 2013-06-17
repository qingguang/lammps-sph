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

nproc=4
ndim=3d
Force=6.12
T=1e7
dname=solvent-H0.5-R0-f${Force}-T${T}

vars="-var ndim ${ndim} -var dname ${dname} -var force ${Force} -var temp ${T}"

mkdir -p ${dname}

rm -rf dum* im* poly* log.lammps

${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd_test_3d.lmp

