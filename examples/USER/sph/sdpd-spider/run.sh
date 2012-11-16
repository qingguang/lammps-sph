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

#rm -rf dum* im* poly* log.lammps

nproc=1
ndim=3d

# polymer configuration
Nbeads=40
Nsolvent=40
# position of the hydrogen bond
nextbond=4

dx=8.333333e-4
nx=220
ny=32
polymer_normal=2
polymer_extbond=3
xbuffer=0.3
xtube=0.3
nstep_del=9000000000

# force between beads
#prefix_gauss=150
prefix_gauss=0

# angle force bond
#prefix_flex=100
prefix_flex=0

dname=fene3d-nb${Nbeads}-ns${Nsolvent}-nx${nx}-next${nextbond}-deposit${nstep_del}-gauss${prefix_gauss}-flex${prefix_flex}

vars="-var prefix_gauss ${prefix_gauss} -var nstep_del ${nstep_del} -var xtube ${xtube} \
-var prefix_flex ${prefix_flex} \
-var xbuffer ${xbuffer} -var dx ${dx} -var ny ${ny} \
-var nx ${nx} -var ndim ${ndim} -var dname ${dname}"

${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} poly3d.restart poly3d.txt

# make wall particles
awk -v wall_type=4 \
    -v dx=${dx} \
    -v ny=${ny} \
    -v xt=${xtube} \
    -v xb=${xbuffer} \
    -v d=-0.0 \
    -v a=0.5 -v b=-0.5 \
    -f makewall3d.awk poly3d.txt > poly3.txt

# -    -v a=0.5 -v b=-0.5 \

mv poly3.txt poly3d.txt

awk -v wall_type=4 -v polymer_normal=${polymer_normal} -v polymer_extbond=${polymer_extbond} \
    -v nextbond=${nextbond} \
    -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
     -f addpolymer.awk poly3d.txt > poly3.txt
awk -v Nbeads=${Nbeads} -v polymer_normal=${polymer_normal} -v polymer_extbond=${polymer_extbond} \
    -f killsmall.awk poly3.txt poly3.txt > poly3d.txt

nangles=$(tail -n 1 poly3d.txt | awk '{print $1}')
nbounds=$(awk '/Angles/{exit} NF' poly3d.txt | tail -n 1  | awk '{print $1}')
sed -e "s/_NUMBER_OF_ANGLES_/$nangles/1" -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" poly3d.txt > poly3.txt
mv poly3.txt poly3d.txt

# output directory name

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
