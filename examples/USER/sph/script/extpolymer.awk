#! /usr/bin/awk -f
# Extract polymer configuration to a directory pdata
# Usage:
# awk -f extpolymer.awk <initial configuration> <punto>
# <initial configuration> is a file with Bonds section
# <punto> is output file in punto format
BEGIN {
    pid=0
    system("mkdir -p pdata")
}

NR == FNR && /^Bonds/ {
    read_bonds_flag = 1
}

read_bonds_flag && (NR == FNR) && (NF>2) {
    id1 = $3
    id2 = $4
    
    if (id1 != prev)  {
	pid++
    }
    phash[id1]=pid
    phash[id2]=pid
    prev = id2
    allpid[pid] = 1
}


NR == FNR {
    next
}

# reading next file
FNR==1 {
    printf("processing file: %s\n", FILENAME) > "/dev/stderr"
    # new line in all polymer files
    for (pid in allpid) {
	if (file[pid]) {
	    printf "\n" >> "pdata/poly." pid
	} else {
	    printf "" > "pdata/poly." pid
	    file[pid]=1
	}
    }
    fl = 0
}

fl{
    id=$1
    if (id in phash) {
	pid = phash[id]
	print $3, $4, $5, $6 >> "pdata/poly." pid
    }
}

/ITEM: ATOMS/ {
    fl=1
}