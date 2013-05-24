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

rm -rf dum* im* poly* log.lammps

nproc=2
ndim=2d
Nbeads=32
nx=48
Nsolvent=3456 #${nx}*${nx}*7/2-${nx}*7/2-${Nbeads}
Force=1e-4
eta=3e-3
H0=0.01
R0=4
Delta=1

# use restart file 0: no, 1: yes
restart=0
restart_file=initial/nb16ns16H0.01R04.dat

#dname=fene-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H0.4-bg1.0-f${Force}-eta${eta}
dname=feex-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H${H0}-R0${R0}-D${Delta}-f${Force}-eta${eta}
#vars="-var nx ${nx} -var Nbeads ${Nbeads} -var Nsolvent ${Nsolvent} -var ndim ${ndim} -var dname ${dname} -var force ${Force}"
vars="-var nx ${nx} -var ndim ${ndim} -var dname ${dname} \ 
      -var force ${Force} -var eta ${eta} \
      -var H0 ${H0} -var R0 ${R0} -var Delta ${Delta} -var Nbeads ${Nbeads} -var Nsolvent ${Nsolvent} \
      -var restart ${restart} -var restart_file ${restart_file} "

${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} poly3d.restart poly3d.txt


 awk -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
     -f addpolymer.awk poly3d.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt

# output directory name

mkdir -p ${dname}
${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
