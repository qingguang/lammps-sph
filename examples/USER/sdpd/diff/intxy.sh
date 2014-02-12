#!/bin/bash

for d in $(ls -d c*); do
    echo $d
    n=$(echo $d | awk -v RS="-" '$1~"^n[0-9]"{gsub("n", ""); print}')
    f=$(ls -1 ${d}/dump*.dat  | tail -n1)
    finput="\"${f}\""
    ktype=laguerrewendland4eps

    if [ ! -f "${f}.smothed" ]; then
	/scratch/prefix-maxima/bin/maxima -r "ktype: ${ktype}$ n: ${n}$ finput: ${finput}$ batchload(\"intxy.mac\")$"
    fi
done



