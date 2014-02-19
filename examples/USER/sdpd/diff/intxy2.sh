#!/bin/bash

tr=1e-3

# needs an older version of maxima becouse of 
# http://article.gmane.org/gmane.comp.mathematics.maxima.general/44570/

for k in laguerrewendland4eps; do
    for n in 3.0 3.5 4.0 4.5 5.0 5.5; do
	dname=c1.0-temp0.00-gamma1.00-eta1e-3-background0.00-nx30-n${n}-ktype${k}-grid0
	nn=$(awk -v tr=${tr} '$13<tr&&NR>3{print NR; exit}' ${dname}/prints/moments_all.dat)
	finput=$(ls ${dname}/dump* | awk -v n=${nn} 'NR==n')
	err=$(awk -v xidx=3 -v yidx=5 -f l1.awk ${finput}*smoothed)
	echo ${n} ${err}
    done
done




