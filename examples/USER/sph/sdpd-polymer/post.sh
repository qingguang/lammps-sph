#! /bin/bash
rm -rf punto.dat
awk 'fl{print $3, $4, $5, $6} /ITEM: ATOMS/{fl=1}' *.dat > punto.dat
awk  -f extpolymer.awk *.dat

octave -qf relaxtime.m
