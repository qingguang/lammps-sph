#! /bin/bash


rm -rf dump*
rm -rf image*

dx=0.025e-3
lmp=../../../../src/lmp_linux
${lmp} -var dx ${dx} -in sdpd-polymer-inti.lmp
../../../../tools/restart2data poly.restart poly.txt

 awk -v cutoff=3.0 -v Nbeads=18 -v Nsolvent=18 -v Npoly=full \
     -f addpolymer.awk poly.txt > poly2.txt
 nbound=$(tail -n 1 poly2.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly2.txt > poly.txt

time /scratch/qingguang/prefix-nana/bin/mpirun -np 8  \
     ${lmp} -var dx ${dx} -in sdpd-polymer-run.lmp

