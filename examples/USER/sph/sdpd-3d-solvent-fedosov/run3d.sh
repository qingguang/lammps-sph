#! /bin/bash

rm du* log*
time mpirun -np 4  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
