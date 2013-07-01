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
ndim=2d
Nbeads=1
Nsolvent=0
sdpd_c=500.0
sdpd_eta=25.0
sdpd_background=0.00
dname=c${sdpd_c}-eta${sdpd_eta}-sdpd_background${sdpd_background}

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background}"

mkdir -p ${dname}
${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} ${dname}/poly3d.restart ${dname}/poly3d.txt

awk -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=0 \
    -f addpolymer.awk ${dname}/poly3d.txt > ${dname}/poly3.txt
nbound=$(tail -n 1 ${dname}/poly3.txt | awk '{print $1}')
sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" ${dname}/poly3.txt > ${dname}/poly3d.txt

# output directory name

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
