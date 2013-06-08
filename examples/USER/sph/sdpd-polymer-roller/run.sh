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
ndim=2d
Nbeads=8
Nsolvent=8
nx=128
Force=64.0
etas=3e-3
etap=3e-3
H0=1.0
R0=4
Delta=1
c=10
# use restart file 0: no, 1: yes
restart=0
restart_file=feex-pert-nb4-ns4-nx64-H1.0-R04-D1-f512.0-etap1.2e-2-c10/sdpd.restart.pert.10000

dname=feex-pert-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H${H0}-R0${R0}-D${Delta}-f${Force}-etap${etap}-c${c}
vars="-var nx ${nx} -var ndim ${ndim} -var dname ${dname} \ 
      -var force ${Force} -var etas ${etas} -var etap ${etap} \
      -var H0 ${H0} -var R0 ${R0} -var Delta ${Delta} -var sdpd_c ${c} \
      -var restart ${restart} -var restart_file ${restart_file}"

function preproc() {
    ${lmp} ${vars} -in sdpd-polymer-init.lmp
    ${restart2data} poly3d.restart poly3d.txt
    awk -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
	-f addpolymer.awk poly3d.txt > poly3.txt
    nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
    sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt
}

mkdir -p ${dname}

preproc
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
