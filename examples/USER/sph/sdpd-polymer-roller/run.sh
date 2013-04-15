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
Nbeads=10
Nsolvent=10
nx=20
Force=30
etas=3e-3
etap=3e-3
H0=0.01
R0=4
Delta=1
c=10
# use restart file 0: no, 1: yes
restart=0
restart_file=initial/nb16ns16H0.01R04.dat

dname=feex-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H${H0}-R0${R0}-D${Delta}-f${Force}-etap${etap}-c${c}
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
