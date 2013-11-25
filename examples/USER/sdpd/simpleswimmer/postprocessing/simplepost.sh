#!/bin/bash

set -e
set -u
cuttime=10
source simplepost-utils.sh
for f in $(find ../supermuc-data/ -name moments_swimmercom.dat); do
    d=$(dirname ${f})/../
    makemsd ${d} ${f}
    slope=$(linreg ${d} 6.0 | awk '{print $1}')
    movingave ${d} ${f}
    gist ${d} ${f}
    echo ${d} ${slope}
    #getp ${d} dt
    echo $(getp ${d} polymer_concentration) $(getp ${d} v_wave) ${slope} >> concentration-v_wave-msdslope.dat
done


