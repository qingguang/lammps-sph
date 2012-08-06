#! /bin/bash

set -e
set -u
configfile=$HOME/lammps-sph-nana.sh
if [ -f "${configfile}" ]; then
    source "${configfile}"
else
    printf "cannot find config file: %s\n" ${configfile} > "/dev/stderr"
    exit -1
fi

rm -rf dum* im* poly* log.lammps

nproc=8
ndim=2d
Nbeads=25
Nsolvent=25
dx=8.333333e-4
nx=256
ny=64
dname=fene-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H0.2-bg1.0-angle

vars="-var dx ${dx} -var ny ${ny} -var nx ${nx} -var ndim ${ndim} -var dname ${dname}"

${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} poly3d.restart poly3d.txt

# make wall particles
awk -v wall_type=3 \
    -v dx=${dx} \
    -v ny=${ny} \
    -v xd=0.3 \
    -v xb=0.1 \
    -v d=-0.0 \
    -v a=0.5 -v b=-1.0 \
    -f makewall.awk poly3d.txt > poly3.txt

mv poly3.txt poly3d.txt

awk -v wall_type=3 -v polymer_type=2 -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
     -f addpolymer.awk poly3d.txt > poly3.txt
nangles=$(tail -n 1 poly3.txt | awk '{print $1}')
nbounds=$(awk '/Angles/{exit} NF' poly3.txt | tail -n 1  | awk '{print $1}')
sed -e "s/_NUMBER_OF_ANGLES_/$nangles/1" -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" poly3.txt > poly3d.txt

# output directory name

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
