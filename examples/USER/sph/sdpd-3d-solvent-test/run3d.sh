#! /bin/bash
git clean -f

time /scratch/qingguang/prefix-nana/bin/mpirun -np 6  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
