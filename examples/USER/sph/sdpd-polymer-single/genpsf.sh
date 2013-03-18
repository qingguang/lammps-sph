#! /bin/bash

set -e
set -u

awk -f addmollabel.awk poly3d.txt poly3d.txt poly3d.txt  > poly3m.txt

input=poly3m.txt
output=poly3d.psf
tmpfile=$(mktemp /tmp/XXXXX)
# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  ${input} angle
animate write psf ${tmpfile}
EOF

sed 's/ NAMD EXT//g' ${tmpfile} > ${output}
