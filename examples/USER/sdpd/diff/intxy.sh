#!/bin/bash

for d in $(ls -d c*ktypequintic); do
    echo $d
    n=$(echo $d | awk -v RS="-" '$1~"^n[0-9]"{gsub("n", ""); print}')
    f=$(ls -1 ${d}/dump*.dat  | tail -n1)
    finput="\"${f}\""

    if [ ! -f "${f}.smothed" ]; then
	maxima -r "n: ${n}$ finput: ${finput}$ batchload(\"intxy.mac\")$"
    fi
done



