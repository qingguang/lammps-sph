#!/usr/bin/awk -f

function isbead(type) {
    if ( (type==polymer_normal) || (type==polymer_extbond) ) {
	return 1
    } else {
	return 0
    }
}

BEGIN {
    if (!length(Nbeads)) {
	printf("Nbeads must be given\n")  > "/dev/stderr"
	exit(-1)
    }
    if (!length(polymer_normal)) {
	printf("Nbeads must be given\n")  > "/dev/stderr"
	exit(-1)
    }
    if (!length(polymer_extbond)) {
	printf("Nbeads must be given\n")  > "/dev/stderr"
	exit(-1)
    }


}


/Atoms/ && NR==FNR {
    inatoms=1
    getline
    next
}

inatoms && NR==FNR {
    id=$1
    type=$2
    
    if ( inpolymer &&  isbead(type) ) {
	nb++
	phash[id]
    }
    else if ( inpolymer &&  !isbead(type) ) {
	if (nb<Nbeads) {
	    for (i in phash) {
		# kill hash 
		khash[i]
	    }
	    # kill this polymer
	} 
	delete phash
	nb=0
	inpolymer=0
    }
    else if ( !inpolymer &&  isbead(type) ) {
	nb++
	phash[id]
	inpolymer=1
    }
    else if ( !inpolymer &&  !isbead(type) ) {
	# do nothing
    }

    next
}

inatoms && (NF==0) && NR==FNR {
    inatoms=0
    nextfile
}

NR == FNR { next }

# the second read of the file

(NF>0)&&($1=="Atoms"){
    inatoms=1
    print
    # skip empty line
    getline
    printf "\n"
    next
}

inatoms && (NF==0) {
    inatoms = 0
    print
    next
}

inatoms {
    id=$1
    if (id in khash) {
	$2=1
    }
    print
    next
}

(NF>0)&&($1=="Bonds"){
    inbonds=1
    print
    # skip empty line
    getline
    printf "\n"
    next
}

inbonds && (NF==0) {
    inbonds = 0
    print
    next
}

inbonds {
    id1=$3
    id2=$4
    if ( !(id1 in khash) && !(id2 in khash) ) {
	ib++
	$1=ib
	print
    }
    next
}

(NF>0)&&($1=="Angles"){
    inangles=1
    print
    # skip empty line
    getline
    printf "\n"
    next
}

inangles && (NF==0) {
    inangles = 0
    print
    next
}

inangles {
    id1=$3
    id2=$4
    id3=$5
    if ( !(id1 in khash) && !(id2 in khash) && !(id3 in khash)) {
	ia++
	$1=ia
	print
    }
    next
}

{
    print
}