#! /bin/bash

set -e
set -u

awk -f ../script/addmollabel.awk poly3d.txt poly3d.txt poly3d.txt > poly3m.txt
tmpfile=$(mktemp /tmp/XXXXX)
output=poly3d.psf
# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  poly3m.txt full
animate write psf ${tmpfile}
EOF

sed 's/ NAMD EXT//g' ${tmpfile} > ${output}
