#! /bin/bash

set -e
set -u

function getLx() {
    awk 'f{print $2; exit} /ITEM: BOX BOUNDS/{f=1} ' ${dname}/stress00000000.dat 
}

function getLy() {
    awk 'f==1{f++; next} f==2{print $2; exit} /ITEM: BOX BOUNDS/{f=1} ' ${dname}/stress00000000.dat 
}


dname=fene-nb5-ns5-nx256-H0.2-bg1.0
# extract polymer to pdata

#awk -f ../script/extpolymer.awk poly3d.txt ${dname}/dump*.dat 
#mv pdata ${dname}/


# for pfile in ${dname}/pdata/*.dat; do
#     echo ${pfile} > "/dev/stderr"
#     awk -v Lx=$(getLx) -v Ly=$(getLy) -f ../script/polymdt.awk ${pfile} > ${pfile/.dat/.mdt}
# done

for pfile in ${dname}/pdata/poly.4.mdt; do
    echo ${pfile} > "/dev/stderr"
    awk -f ../script/polyext.awk ${pfile}
done > ${dname}/extension.dat
