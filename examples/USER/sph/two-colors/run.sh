#! /bin/bash

dname=data
mpirun -np 4  ../../../../src/lmp_linux -in colors.lmp -var dname ${dname}

