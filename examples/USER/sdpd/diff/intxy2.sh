#!/bin/bash

tr=3.0e-5

# needs an older version of maxima becouse of 
# http://article.gmane.org/gmane.comp.mathematics.maxima.general/44570/

for k in wendland6; do
    for n in 3.00 3.50 4.00 4.50 5.00 5.50 6.00; do
	c=$(awk -v n=${n} '$1==n{print $2}' par.dat)
	dname=c${c}-temp0.00-gamma1.00-eta1.0-background0.00-nx30-n${n}-ktype${k}-grid0
	nn=$(awk -v tr=${tr} '$13<tr&&NR>3{print NR; exit}' ${dname}/prints/moments_all.dat)
	finput=$(ls ${dname}/dump* | awk -v n=${nn} 'NR==n')
	#err=$(awk -v xidx=3 -v yidx=5 -f l1.awk ${finput}*smoothed)
	err=$(awk -v n=${nn} 'NR==n{print $2; exit}' ${dname}/prints/error_all.dat)
	echo ${n} ${err}
    done
done




