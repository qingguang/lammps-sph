BEGIN {
    system("mkdir -p pdata")
    # read ids from poly.id file
    while (getline line < "poly.id" > 0) {
	split(line, a, " ");
	id=a[1]
	pid=a[2]
	phash[id]=pid

	allpid[pid]=1
    }
}

# reading next file
FNR==1 {
    # new line in all polymer files
    for (pid in allpid) {
	if (NR>1) {
	    printf "\n" >> "pdata/poly." pid
	} else {
	    printf "" > "pdata/poly." pid
	}
    }
    fl = 0
}

fl{
    id=$5
    if (id in phash) {
	pid = phash[id]
	print $1, $2, $3, $4 >> "pdata/poly." pid
    }
}

/ITEM: ATOMS/ {
    fl=1
}
