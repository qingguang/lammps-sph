#! /bin/bash


rm -rf dump*
rm -rf image*

lmp=../../../../src/lmp_linux
${lmp} -in sdpd-polymer-inti.lmp
../../../../tools/restart2data poly.restart poly.txt

 awk -v cutoff=3.0 -v Nbeads=10 -v Nsolvent=10 -v Npoly=full \
     -f addpolymer.awk poly.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly.txt

time /opt/mpich/bin/mpirun -np 2  \
     ${lmp} -in sdpd-polymer-run.lmp

