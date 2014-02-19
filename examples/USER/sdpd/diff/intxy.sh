#!/bin/bash

tr=1e-3

# needs an older version of maxima becouse of 
# http://article.gmane.org/gmane.comp.mathematics.maxima.general/44570/

for k in laguerrewendland4eps wendland6 quintic ; do
    for n in 3.0 3.5 4.0 4.5 5.0 5.5; do
	dname=c1.0-temp0.00-gamma1.00-eta1e-3-background0.00-nx30-n${n}-ktype${k}-grid0
	nn=$(awk -v tr=${tr} '$13<tr&&NR>3{print NR; exit}' ${dname}/prints/moments_all.dat)
	finput=$(ls ${dname}/dump*.dat | awk -v n=${nn} 'NR==n')
	finput="\"${finput}\""
	/scratch/prefix-maxima-v5.28.0/bin/maxima -r "ktype: ${k}; ncut: ${n}$ finput: ${finput}$ batchload(\"intxy.mac\")$"
    done
done




