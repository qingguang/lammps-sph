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
# choose case "roller" "kolmogorov" "wall" "deform" "RPF"
case=wall
#case=roller
nproc=2
ndim=2d
Nbeads=5
Nsolvent=5
nx=20
#Force=164
Force=20
etas=3e-2
etap=3e-2
H0=3
R0=4
Delta=1.0
rate=2e2
dname=feex-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H${H0}-R0${R0}-D${Delta}-f${Force}-etap${etap}
#dname=harmonic-nb${Nbeads}-ns${Nsolvent}-nx${nx}-H${H0}-R0${R0}-f${Force}-etap${etap}
vars="-var nx ${nx} -var ndim ${ndim} -var dname ${dname} -var case ${case} \ 
      -var force ${Force} -var etas ${etas} -var etap ${etap} \
      -var H0 ${H0} -var R0 ${R0} -var Delta ${Delta} -var rate ${rate}"
mkdir -p ${dname}
${lmp} ${vars} -in sdpd-polymer-init.lmp
${restart2data} ${dname}/poly3d.restart ${dname}/poly3d.txt


 awk -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=${Nsolvent} -v Npoly=full \
     -f addpolymer.awk ${dname}/poly3d.txt > ${dname}/poly3.txt
 nbound=$(tail -n 1 ${dname}/poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" ${dname}/poly3.txt > ${dname}/poly3d.txt
rm ${dname}/poly3.txt ${dname}/poly3d.restart 
# output directory name

${mpirun} -np ${nproc} ${lmp} ${vars} -in sdpd-polymer-run.lmp
