BEGIN {
    system("mkdir -p solvent")
}

# reading next file
FNR==1 {
    # new line in all polymer files
    if (NR>1) {
	printf "\n" >> "solvent/id." id
    } else {
	printf "" > "solvent/id." id
    }
    fl = 0
}

fl{
    id=$1
    print $3, $4, $5, $6, $7, $8 >> "solvent/id." id

}

/ITEM: ATOMS/ {
    fl=1
}
