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

nproc=8
ndim=3d

# polymer configuration
Nbeads=20
Nsolvent=600

dx=8.333333e-4
nx=32
ny=32
nz=12
polymer_normal=2
xt=0.2
yt=0.15

# force between beads
#prefix_gauss=150
prefix_gauss=0

# angle force bond
prefix_flex=50

dname=fene${ndim}-nb${Nbeads}-ns${Nsolvent}-nx${nx}-xt${xt}-yt${yt}-restart

vars="-var prefix_gauss ${prefix_gauss} -var yt ${yt} -var xt ${xt} \
-var prefix_flex ${prefix_flex} \
-var dx ${dx} -var ny ${ny} -var nz ${nz} \
-var nx ${nx} -var ndim ${ndim} -var dname ${dname}"

function preproc() {
    ${lmp} ${vars} -in sdpd-polymer-init.lmp
    ${restart2data} poly3d.restart poly3d.txt

    # make wall particles
    awk -v wall_type=4 \
	-v dx=${dx} \
	-v ny=${ny} \
	-v xt=${xt} \
	-v yt=${yt} \
	-f contraction.awk poly3d.txt > poly3.txt

    mv poly3.txt poly3d.txt

    awk -v wall_type=4 -v polymer_normal=${polymer_normal} \
	-v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
	-f addpolymer.awk poly3d.txt > poly3.txt

    awk -v Nbeads=${Nbeads} -v polymer_normal=${polymer_normal} -v polymer_normal=${polymer_normal} \
	-f killsmall.awk poly3.txt poly3.txt > poly3d.txt

    nangles=$(tail -n 1 poly3d.txt | awk '{print $1}')
    nbounds=$(awk '/Angles/{exit} NF' poly3d.txt | tail -n 1  | awk '{print $1}')
    sed -e "s/_NUMBER_OF_ANGLES_/$nangles/1" -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" poly3d.txt > poly3.txt
    mv poly3.txt poly3d.txt
}


# output directory name

mkdir -p ${dname}
preproc
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
