# add molecule-tag to all connected atoms

function isdiff(f,s) {
    return moltag[f]!=moltag[s]
}

function mintag(f,s) {
    if (moltag[f]<moltag[s]) {
	return moltag[f]
    } else {
	return moltag[s]
    }
}

FNR==1 {
    ifile++
}

ifile==1 && $0=="Bonds"{
    # first pass
    inbonds = 1
    getline
    next
}

ifile==1 && inbonds && (!NF) {
    inbonds = 0
    next
}

ifile==1 && inbonds {
    bnd1[$1]=$3
    bnd2[$1]=$4
    polymer[$3]=1
    polymer[$4]=1
    bonds[$1]=1
    next
}

ifile==2 && $0=="Atoms" {
    inatoms = 1
    getline
    next
}

ifile==2 && inatoms && !NF {
    inatoms = 0
    next
}

ifile==2 && inatoms {
    atm[$1]=$0
    if ( $1 in polymer) {
	mt++
	moltag[$1]=mt
    } else {
	moltag[$1]=0
    }
    next
}

ifile==3 && FNR==1 {
    do {
	flag=0
	for (ibnd in bonds) {
	    fst = bnd1[ibnd]
	    scn = bnd2[ibnd]
	    if (isdiff(fst, scn)) {
		moltag[fst] = mintag(fst,scn)
		moltag[scn] = moltag[fst]
		flag=1
	    }
	}
    } while (flag)
    print
    next
}

ifile==3 && $0=="Atoms" {
    print
    inatoms = 1
    getline
    printf "\n"
    next
}

ifile==3 && inatoms && !NF {
    inatoms = 0
    print
    next
}

ifile==3 && inatoms {
    tag = moltag[$1]
    if (!(tag in tag_hash)) {
	maxtag++
	tag_hash[tag]=maxtag
    }
    $1=$1" "tag_hash[tag]
    print
    next
}

ifile==3 {
    print
    next
}