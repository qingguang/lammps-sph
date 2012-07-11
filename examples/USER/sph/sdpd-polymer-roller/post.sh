#! /bin/bash
rm -rf punto.dat
awk 'fl{print $3, $4,$5, $6, $7, $8} /ITEM: ATOMS/{fl=1}' *.dat > punto.dat
#for filename in dump*.dat; do echo $filename;  sed '1,8d' $filename > ${filename/.dat/.del};done
#awk 'fl{print $1, $2, $3, $4} /ITEM: ATOMS/{fl=1}' *.del > punto.dat

