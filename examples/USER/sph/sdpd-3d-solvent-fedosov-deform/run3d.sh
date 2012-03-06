#! /bin/bash
rm *.jpg *.dat vx.av

configfile=$HOME/lammps-sph.sh
if [ -f "${configfile}" ]; then
    source "${configfile}"
else
    printf "cannot find config file: %s\n" ${configfile} > "/dev/stderr"
    exit -1
fi

rm du* log*
time  ${mpirun} -np 2 ${lmp} -in sdpd_test_3d.lmp
