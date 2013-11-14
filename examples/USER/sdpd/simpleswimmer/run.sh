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
v_wave=50

dsize=150
K_wave=500
T_wave=20

dsize=150
dname=supermuc-data/c${sdpd_c}-nbeads${Nbeads}-nsolvent${Nsolvent}-K_wave${K_wave}-T_wave${T_wave}-v_wave${v_wave}-dsize${dsize}mass3
Nbeadsinswimmer=40

vars="-var ndim ${ndim} -var dname ${dname} -var sdpd_c ${sdpd_c} -var K_wave ${K_wave} -var T_wave ${T_wave} -var v_wave ${v_wave} -var dsize ${dsize} -var sdpd_eta ${sdpd_eta} -var sdpd_background ${sdpd_background}"

mkdir -p ${dname}

${lmp} ${vars} -in initial.lmp
awk --lint=fatal -v Nbeadsinswimmer=${Nbeadsinswimmer}  -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
    -f addswimmer.awk ${dname}/sdpd.data > ${dname}/sdpd-with-poly.data.aux

nbounds=$(awk '/Angles/{exit} NF' ${dname}/sdpd-with-poly.data.aux | tail -n 1  | awk '{print $1}')
sed -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" ${dname}/sdpd-with-poly.data.aux > ${dname}/sdpd-with-poly.data

cp *.lmp ${dname}/

echo "${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp" > ${dname}/run.command
if [ $(hostname) = "login05" ]; then
    rfile=$(mktemp -u submit.XXXXXXX.sh)
    p=$(pwd)
    sed -e "s,M4_COMMAND,${lmp} ${vars} -in solvent.lmp,g" \
	-e "s,M4_DNAME,${p},g" run.m4.sh \
	-e "s,M4_JOB_NAME,${rfile},g" > ${rfile}
    llsubmit ${rfile}
    cp ${rfile} ${dname}/
    printf "submitting file: %s\n" ${rfile}
else
    ${mpirun} -np ${nproc} ${lmp} ${vars} -in solvent.lmp
fi
#

