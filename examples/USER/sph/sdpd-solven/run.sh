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

nproc=1
ndim=3d
sdpd_eta=25.0
sdpd_background=0.00
sdpd_c=$1
dname=c${sdpd_c}-ndim${ndim}-eta${sdpd_eta}-sdpd_background${sdpd_background}

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background}"

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
