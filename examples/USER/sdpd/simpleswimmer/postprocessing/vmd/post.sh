#!/bin/bash

set -e
set -u

dumpdir=../../supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave50-dsize150mass3/
 ../../lammps2punto.sh ${dumpdir}/confs/dump.*.dat > punto.dat
awk -f /scratch/work/lammps-org/lammps-configs/step-by-step/vmd/punto2vmd/punto2xyz.awk punto.dat > punto.xyz

awk --lint=fatal -f tomol.awk ${dumpdir}/sdpd-with-poly.data > poly.data
bash genpsf.sh  poly.data
