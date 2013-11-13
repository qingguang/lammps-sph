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
sdpd_eta=25.0
sdpd_background=0.0
sdpd_c=3e2
Nbeads=10
Nsolvent=5
dname=c${sdpd_c}-ndim${ndim}-eta${sdpd_eta}-sdpd_background${sdpd_background}-nbeads${Nbeads}-nsolvent${Nsolvent}-test
Nbeadsinswimmer=40

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background}"
mkdir -p ${dname}

${lmp} ${vars} -in initial.lmp
awk --lint=fatal -v Nbeadsinswimmer=${Nbeadsinswimmer}  -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
    -f addswimmer.awk ${dname}/sdpd.data > ${dname}/sdpd-with-poly.data.aux

nbounds=$(awk '/Angles/{exit} NF' ${dname}/sdpd-with-poly.data.aux | tail -n 1  | awk '{print $1}')
sed -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" ${dname}/sdpd-with-poly.data.aux > ${dname}/sdpd-with-poly.data

cp *.lmp ${dname}/

echo "${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp" > ${dname}/run.command
${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
