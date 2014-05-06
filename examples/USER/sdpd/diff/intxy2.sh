#!/bin/bash

tr=3.0e-5
set -e
set -u

for k in wendland6; do
    for n in 3.00 3.50 4.00 4.50 5.00 5.50 6.00; do
	eta=$(awk -v n=${n} '$1==n{print $2}' par.dat)
	dname=$(ls -d c4.20-temp0.00-gamma1.00-eta${eta}-background0.00-nx*-n${n}-ktype${k}-grid0-beta)
	# dname=c${c}-temp0.00-gamma1.00-eta1.0-background0.00-nx30-n${n}-ktype${k}-grid0
	nn=$(awk -v tr=${tr} '$13<tr&&NR>3{print NR; exit}' ${dname}/prints/moments_all.dat)
	finput=$(find ${dname} -name 'dump[0-9]*.dat' | sort -g | awk -v n=${nn} 'NR==n')
	err_ma2=$(awk -v xidx=10 -v yidx=11 -f l1.awk ${finput})
	err_sm=$(awk -v xidx=5 -v yidx=3 -f l1.awk ${finput}*smoothed)
	err_ma=$(awk -v xidx=4 -v yidx=5 -f l1.awk ${finput}*smoothed)
	err=$(awk -v n=${nn} 'NR==n{print $2; exit}' ${dname}/prints/error_all.dat)
	echo ${n} ${err} ${err_sm} ${err_ma} ${err_ma2} | \
	    awk -v n=${n} '{maxD=2*3.141592653589793*n/3.0 * 1.2; print $1, $2, $3/maxD, $4/maxD, $5/maxD}'
    done > l1.${k}.tr${tr}
done




