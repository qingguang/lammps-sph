BEGIN {
    if (length(fraction)==0) {
	print "fraction must be given\n" > "/dev/stderr"
	exit(-1)
    }
}

$1=="Atoms" {
    inatom=1
    print
    getline
    print
    next
}

!inatom {
    print
    next
}

inatom && (!NF) {
    inatom=0
    print
    next
}

inatom {
    if (rand()<fraction) {
	$2=2
    }
    print
    next
}

