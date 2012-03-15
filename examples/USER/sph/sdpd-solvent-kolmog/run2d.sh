#! /bin/bash

rm du* log* img*
time /scratch/qingguang/prefix-nana/bin/mpirun -np 2  ../../../../src/lmp_linux -in sdpd_test_2d.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
