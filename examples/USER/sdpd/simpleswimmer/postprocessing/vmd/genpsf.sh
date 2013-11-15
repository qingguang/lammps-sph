#! /bin/bash

set -e
set -u

inputfile="$1"
tmpfile=$(mktemp /tmp/XXXXX)
output=poly3d.psf
# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  ${inputfile} molecular
animate write psf ${tmpfile}
EOF

sed 's/ NAMD EXT//g' ${tmpfile} > ${output}
printf "writing: %s\n" ${output}
