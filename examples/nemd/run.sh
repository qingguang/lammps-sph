#!/bin/bash
#$-M sparkallenxie@gmail.com
#$-S /bin/bash
#$-N lammps-test
#$-o $HOME/lammps-nemd.${JOB_ID}.out -j y
#$-l h_rt=00:05:00
#$-l march=x86_64
#$-pe mpi_8 8
. /etc/profile
cd ${HOME}/work/lammps-sph/examples/nemd/
mpiexec -n 8 $HOME/work/lammps-sph/src/lmp_linux -in in.nemd

