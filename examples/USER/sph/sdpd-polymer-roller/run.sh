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


nproc=6
ndim=2d
<<<<<<< HEAD
Nbeads=24
Nsolvent=24
Force=164
nx=96
eta=3e-2
dname=fene-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H0.5-bg1.0-f${Force}-eta${eta}-T1e13
=======
Nbeads=16
Nsolvent=16
nx=32
Force=81
eta=3e-2
dname=fene-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H0.01-bg1.0-f${Force}-eta${eta}
>>>>>>> 4c9841d2424360dbd4c4f2b5f5655aa2583abb79

vars="-var nx ${nx} -var ndim ${ndim} -var dname ${dname} -var force ${Force} -var eta ${eta}"

${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} poly3d.restart poly3d.txt


 awk -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
     -f addpolymer.awk poly3d.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt

# output directory name

mkdir -p ${dname}
<<<<<<< HEAD
=======
#${mpirun -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
>>>>>>> 4c9841d2424360dbd4c4f2b5f5655aa2583abb79
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
