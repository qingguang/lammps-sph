#! /bin/bash

nx=121
dname=data-wall-nx${nx}

# number of case
icase=2
mkdir -p ${dname}
 ../../../../src/lmp_linux -in droplet.lmp -var icase ${icase} -var dname ${dname} -var nx ${nx}
