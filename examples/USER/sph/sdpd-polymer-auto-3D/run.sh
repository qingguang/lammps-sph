#! /bin/bash

#git clean -f
srun_ps ../../../../src/lmp_linux -in sdpd-polymer3D-inti.lmp
../../../../tools/restart2data poly3d.restart poly3d.txt


 awk -v cutoff=3.0 -v Nbeads=15 -v Nsolvent=0 -v Npoly=full \
     -f addpolymer.awk poly3d.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt

srun_ps ../../../../src/lmp_linux -in sdpd-polymer3D-run.lmp
#../../../../src/lmp_linux -in sdpd-polymer-run.lmp
