#! /usr/bin/awk -f
# A script to average lammps "fix ave/spatial" data
# nskip is a number of snapshots to skip in averaging

# Usage:
# ../script/av.awk -v nskip=3 sxx.av

BEGIN {
}

/^#/ {
    next
}

NF==2 {
    # next snapshot
    nsnap++
    next
}

nsnap>nskip {
    n=$1
    if (n>maxn) maxn=n
    # save coordinates and average 4th column
    x[n]=$2
    nsn[n]++
    av[n]+=$4
}

END {
    # output
    for (k=1; k<=maxn; k++) {
	print x[k], av[k]/nsn[k]
    }
}