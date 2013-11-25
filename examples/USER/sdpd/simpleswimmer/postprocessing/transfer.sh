#!/bin/bash

rsync -av -e '/home/litvinov/bin/chain-ssh -t litvinov@yoko ssh' \
    --include='*/' \
    --include='*moments_swimmercom.dat' --include 'dump.000000000.dat' \
    --include='*vars.lmp' --include='run.command' \
    --include='dump.*00000.dat' --include='img.*00000.dat' \
    --include='*sdpd-with-poly.data' \
    --include='*swimmer_confs_unwrapped/swimmer.*.dat' \
    --include='*.avi' \
    --exclude '*' \
    lu79buz2@supermuc.lrz.de:~/work/lammps-sdpd/examples/USER/sdpd/simpleswimmer/supermuc-data/ ../supermuc-data/ 

