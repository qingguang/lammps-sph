#!/bin/bash

set -e
set -u
cuttime=30
source simplepost-utils.sh
for f in $(find ../supermuc-data/ -name moments_swimmercom.dat); do
    d=$(dirname ${f})/../
    makemsd ${d}
    #slope=$(linreg ${d} 6.0 | awk '{print $1}')
    #echo $(getp ${d} polymer_concentration) $(getp ${d} v_wave) ${slope} >> concentration-v_wave-msdslope.dat
done


