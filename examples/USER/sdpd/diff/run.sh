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

nproc=1
ndim=2
sdpd_eta=8.0
sdpd_background=0.0
sdpd_c=5e1
nx=30
n=3.5
ktype=laguerrewendland4

dname=c${sdpd_c}-ndim${ndim}-eta${sdpd_eta}-sdpd_background${sdpd_background}-nx${nx}-n${n}-ktype${ktype}

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} \
      -var nx   ${nx} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background} \
      -var  n   ${n} -var ktype ${ktype}"

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
