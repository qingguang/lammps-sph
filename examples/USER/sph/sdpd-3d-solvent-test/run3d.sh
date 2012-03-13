#! /bin/bash

mpiexec -n 4  ../../../../src/lmp_linux -in sdpd_test_3d.lmp

<<<<<<< HEAD
<<<<<<< HEAD
=======
time /scratch/qingguang/prefix-nana/bin/mpirun -np 1  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
=======
time /scratch/qingguang/prefix-nana/bin/mpirun -np 3  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
>>>>>>> db5e91127163e9ed31415457ecf862b553bae011
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
>>>>>>> e6eb88fabef03d4688324629c9312ca84adc68b3
