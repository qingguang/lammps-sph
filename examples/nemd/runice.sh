#!/bin/bash
#SBATCH -o $HOME/lammps-nemd.%j.%N.out
#SBATCH -D $HOME/work/lammps-sph/examples/nemd
#SBATCH -J lammps-test
#SBATCH --get-user-env
#SBATCH --clusters ice1
#SBATCH --ntasks=64

#SBATCH --mail-type=end
#SBATCH --mail-user=sparkallenxie@gmail.com
#SBATCH --export=NONE
#SBATCH --time=00:08:00


source /etc/profile.d/modules.sh

cd $HOME/work/lammps-sph/examples/nemd
srun_ps ./$HOME/work/lammps-sph/src/lmp_linux < in.nemd
