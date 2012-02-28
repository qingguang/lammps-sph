#!/bin/bash
#$-m e
#$-m b
#$-M sparkallenxie@gmail.com
#$-S /bin/bash
#$-N lammps-test
#$-o $HOME/lammps-building.${JOB_ID}.out -j y
#$-l h_rt=00:05:00
#$-l march=x86_64
#$-pe mpi_8 8
. /etc/profile
module load lammps
cd ${HOME}/work/lammps-sph/examples/nemd/
mpiexec -n ${NSLOTS} $HOME/work/lammps-sph/src/lmp_linux -in in.nemd 
