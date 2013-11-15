BEGIN {
    inatoms=0
}

(NF>0)&&($1=="Atoms") {
    inatoms=1
    print
    getline
    printf "\n"
    next
}

inatoms && (NF==0) {
    inatoms=0
    print
    getline
    print
    next
}

inatoms {
    # http://lammps.sandia.gov/doc/read_data.html
           # atom-ID, atom-type,  x,  y,  z, molecule-ID, rho, e, cv, image-flag, image-flag, image-flag
           #       1,         2,  3,  4,  5,           6,   7, 8,  9,         10,         11,         12
    print         $1,        $6, $2, $3, $4, $5
    #print
    next
}

{
    print
}
