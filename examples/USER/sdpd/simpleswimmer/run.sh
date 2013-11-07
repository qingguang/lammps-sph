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
sdpd_eta=25.0
sdpd_background=0.0
sdpd_c=1e2
dname=c${sdpd_c}-ndim${ndim}-eta${sdpd_eta}-sdpd_background${sdpd_background}
Nbeadsinswimmer=20

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background}"
mkdir -p ${dname}

function preproc() {
    ${lmp} ${vars} -in initial.lmp

    awk --lint=fatal -v Nbeadsinswimmer=${Nbeadsinswimmer}  \
	-f addswimmer.awk ${dname}/sdpd.data > ${dname}/sdpd-with-poly.data
}

preproc
${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
