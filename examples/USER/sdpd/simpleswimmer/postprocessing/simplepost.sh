#!/bin/bash

cuttime=30
source simplepost-utils.sh
for f in $(find ../supermuc-data/ -name moments_swimmercom.dat); do
    d=$(dirname ${f})
    makemsd ${d}
done


