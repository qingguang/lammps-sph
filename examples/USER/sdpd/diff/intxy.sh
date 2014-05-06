#!/bin/bash

# needs an older version of maxima becouse of 
# http://article.gmane.org/gmane.comp.mathematics.maxima.general/44570/
MAXIMA=/scratch/prefix-maxima-v5.28.0/bin/maxima
#MAXIMA=maxima
tr=3.0e-5
set -e
set -u

for k in wendland6 laguerrewendland4eps; do
    for n in 3.00 3.50 4.00 4.50 5.00 5.50 6.00; do
	eta=$(awk -v n=${n} '$1==n{print $2}' par.dat)
	dname=$(ls -d c4.20-temp0.00-gamma1.00-eta${eta}-background0.00-nx*-n${n}-ktype${k}-grid0-beta)
	nn=$(awk -v tr=${tr} '$13<tr&&NR>3{print NR; exit}' ${dname}/prints/moments_all.dat)
	finput=$(find ${dname} -name 'dump[0-9]*.dat' | sort -g | awk -v n=${nn} 'NR==n')
	finput="\"${finput}\""
	${MAXIMA} -r "ktype: ${k}; ncut: ${n}$ finput: ${finput}$ batchload(\"intxy-tmp.mac\")$"
    done
done




