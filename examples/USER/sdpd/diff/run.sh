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
sdpd_eta=1.0
sdpd_background=0.00
sdpd_c=10.00
sdpd_gamma=1.00
nx=30
n=3.80
ktype=wendland4
temp=0.0001

dname=c${sdpd_c}-temp${temp}-gamma${sdpd_gamma}-eta${sdpd_eta}-background${sdpd_background}-nx${nx}-n${n}-ktype${ktype}-p0.1

vars="-var sdpd_gamma ${sdpd_gamma} -var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} \
      -var nx   ${nx} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background} \
      -var  n   ${n} -var ktype ${ktype} -var temp ${temp}"

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
