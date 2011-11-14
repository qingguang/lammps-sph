#! /bin/bash
rm -rf punto.dat
awk -f post.awk  $(ls -1 dump.*.dat | sort -t . -k 3  -n)  > punto.dat
