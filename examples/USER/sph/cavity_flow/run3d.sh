#! /bin/bash

rm du* log*
time /scratch/qingguang/prefix-nana/bin/mpirun -np 1  ../../../../src/lmp_linux -in cavity_flow.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
