#! /bin/bash

Lx=1.2
for dname in $(ls -d c*back*); do
    bash ../script/lammps2punto.sh ${dname}/dump* > ${dname}/punto.dat
    rdf --nskipsnap 1 -d 3 -m 0.5 -x ${Lx} -y ${Lx} -z ${Lx} ${dname}/punto.dat  > ${dname}/rdf.dat

    for id in $(seq 1 500); do
	printf "id: %i\n" ${id} > "/dev/stderr"
	awk -v id=${id} '(NR>1)&&(FNR==1){printf "\n"; f=0} f&&$1==id{print $3, $4, $5}; /ITEM: ATOMS/{f=1}' ${dname}/dump* \
	    > ${dname}/id${id}
	awk -v maxx=${Lx} -f ~/google-svn/awk/polymer/tophys3d.awk ${dname}/id${id} | grep . > ${dname}/id.${id}.phys
	msd -d 3 -f ${dname}/id.${id}.phys > ${dname}/msd.${id}
    done
    dt=$(awk '!($2~"dt")&&$1=="timestep"{print $2}' ${dname}/log.lammps)
    printf "dt: %e\n" ${dt} > "/dev/stderr"
    ~/google-svn/awk/avfiles.awk ${dname}/msd.* | awk -v dt=${dt} '{print dt*(NR-1), $1}' > ${dname}/all.msd
done


