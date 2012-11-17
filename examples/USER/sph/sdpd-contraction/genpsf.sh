#! /bin/bash

set -e
set -u

input=poly3d.txt
output=poly3d.psf
tmpfile=$(mktemp /tmp/XXXXX)
# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  ${input} full
animate write psf ${tmpfile}
EOF

sed 's/ NAMD EXT//g' ${tmpfile} > ${output}
