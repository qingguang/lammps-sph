#! /bin/bash

set -e
set -u
configfile=$HOME/lammps-sdpd.sh
if [ -f "${configfile}" ]; then
    source "${configfile}"
else
    printf "cannot find config file: %s\n" ${configfile} > "/dev/stderr"
    exit -1
fi

nproc=8
ndim=2
sdpd_eta=1e-5
sdpd_background=1.0
sdpd_c=1.00
sdpd_gamma=0.00
nx=32
n=3.00
#ktype=laguerre2wendland4eps
ktype=quintic

dname=c${sdpd_c}-gamma${sdpd_gamma}-eta${sdpd_eta}-sdpd_background${sdpd_background}-nx${nx}-n${n}-ktype${ktype}

vars="-var sdpd_gamma ${sdpd_gamma} -var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} \
      -var nx   ${nx} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background} \
      -var  n   ${n} -var ktype ${ktype}"

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
