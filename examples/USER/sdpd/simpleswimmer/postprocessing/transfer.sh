#!/bin/bash

rsync -av -e '/home/litvinov/bin/chain-ssh -t litvinov@yoko ssh' \
    --include='*/' \
    --include='*moments_swimmercom.dat' --include 'dump.000000000.dat' \
    --include='*vars.lmp' --include='run.command' \
    --exclude '*' \
    lu79buz2@supermuc.lrz.de:~/work/lammps-sdpd/examples/USER/sdpd/simpleswimmer/supermuc-data/ ../supermuc-data/ 

