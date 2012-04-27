#! /bin/bash



rm -rf dum* im* poly* log.lammps
../../../../src/lmp_linux -in sdpd-polymer3D-inti.lmp
../../../../tools/restart2data poly3d.restart poly3d.txt


<<<<<<< .merge_file_jOt8Gq
 awk -v cutoff=3.0 -v Nbeads=6 -v Nsolvent=2 -v Npoly=full \
=======
 awk -v cutoff=3.0 -v Nbeads=10 -v Nsolvent=10 -v Npoly=full \
>>>>>>> .merge_file_Amxihq
     -f addpolymer.awk poly3d.txt > poly3.txt
 nbound=$(tail -n 1 poly3.txt | awk '{print $1}')
 sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" poly3.txt > poly3d.txt

date
time /scratch/qingguang/prefix-nana/bin/mpirun -np 2  ../../../../src/lmp_linux -in sdpd-polymer3D-run.lmp
date
#mpirun  -np 2 ../../../../src/lmp_linux -in sdpd-polymer3D-run.lmp
#../../../../src/lmp_linux -in sdpd-polymer-run.lmp
