#! /bin/bash

awk '/ITEM: ATOMS/{fl=1} fl{print $3, $4}' *.dat
