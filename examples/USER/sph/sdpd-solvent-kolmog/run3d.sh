#! /bin/bash

rm du* log* ima*
time mpirun -np 6  ../../../../src/lmp_linux -in sdpd_test_3d.lmp
#../../../../src/lmp_linux -in sdpd_test_3d.lmp
