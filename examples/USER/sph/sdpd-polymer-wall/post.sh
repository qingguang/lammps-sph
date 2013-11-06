#! /bin/bash
rm -rf punto.dat
rm -rf pdata
for filename in dump0*.dat; do echo $filename;  sed '1,8d' $filename > ${filename/.dat/.del};done
awk 'fl{print $1, $2, $3, $4} /ITEM: ATOMS/{fl=1}' *.del > punto.dat
#awk -f extpolymer.awk dump*.dat
#octave -q --eval "ext"

