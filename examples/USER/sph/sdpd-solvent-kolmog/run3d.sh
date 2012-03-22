#! /bin/bash

rm du* log* ima*
time /scratch/qingguang/prefix-nana/bin/mpirun -np 6  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
