#! /bin/bash




../../../../src/lmp_linux -in sdpd-polymer-inti.lmp
../../../../tools/restart2data poly.restart poly.txt


 awk -v cutoff=3.0 -v Nbeads=9 -v Nsolvent=18 -v Npoly=full \
     -f addpolymer.awk poly.txt > poly2.txt

 nangles=$(tail -n 1 poly2.txt | awk '{print $1}')
 nbounds=$(awk '/Angles/{exit} NF' poly2.txt | tail -n 1  | awk '{print $1}')

 sed -e "s/_NUMBER_OF_ANGLES_/$nangles/1" -e "s/_NUMBER_OF_BOUNDS_/$nbounds/1" poly2.txt > poly.txt


#how to replace _NUMBER_OF_BONDS_ with the number?

#mpirun  -np 1 ../../../../src/lmp_linux -in sdpd-polymer-run.lmp
../../../../src/lmp_linux -in sdpd-polymer-run.lmp
