#! /bin/bash

set -e
set -u
configfile=$HOME/lammps-rs.sh
if [ -f "${configfile}" ]; then
    source "${configfile}"
else
    printf "cannot find config file: %s\n" ${configfile} > "/dev/stderr"
    exit -1
fi


nproc=8
ndim=2d
nx=128
Force=30
etas=3e-3
etap=3e-3
c=10
alpha=$1
sdpd_background=0.95
fraction=0.5
# use restart file 0: no, 1: yes
restart=0
restart_file=initial/nb16ns16H0.01R04.dat

dname=feex-pert-fraction${fraction}-nx${nx}-f${Force}-etap${etap}-c${c}-alpha${alpha}-bg${sdpd_background}
vars="-var nx ${nx} -var ndim ${ndim} -var dname ${dname} \ 
      -var force ${Force} -var etas ${etas} -var etap ${etap} \
      -var sdpd_c ${c} \
      -var restart ${restart} -var restart_file ${restart_file} \
      -var alpha ${alpha} -var sdpd_background ${sdpd_background}"

function preproc() {
    ${lmp} ${vars} -in sdpd-polymer-init.lmp
    ${restart2data} poly3d.restart poly3d.txt
    awk -v fraction=${fraction} \
	-f addphase.awk poly3d.txt > poly3.txt
    cp poly3.txt poly3d.txt
}

mkdir -p ${dname}

preproc
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
