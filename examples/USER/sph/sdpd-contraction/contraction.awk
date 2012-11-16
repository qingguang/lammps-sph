# 

function fabs(var) {
  return var>0?var:-var
}

function iswall(Rx, Ry, Rz) {
    Lx = box[x,hi]-box[x,lo]
    Ly = box[y,hi]-box[y,lo]
    Lz = box[z,hi]-box[z,lo]
    
    # xt is a contraction part (in fraction of Lx)
    # yt is a contraction part (in fraction of Ly)
    xt_real = xt* Lx
    xb_real = 0.5*(Lx - xt_real)
    yt_real = yt * Ly
    
    #
    # |--- buffer (xb) ---|--- contraction (xt) ---|--- buffer (xb) ---- 
    # 
    if (Rx<xb_real) {
	if (Ry<=2*dx) {
	    return 1
	} 
	if (Ry>=(ny-3)*dx) {
	    return 1
	}
	return 0
    }

    if (Rx>xt_real+xb_real) {
	if (Ry<=2*dx) {
	    return 1
	} 
	if (Ry>=(ny-3)*dx) {
	    return 1
	}
	return 0
    }

    # middle part
    ymin = 0.5*(Ly - yt_real)
    ymax = yt_real + ymin
    if (Ry<=ymin) {
	return 1
    } 
    if (Ry>=ymax) {
	return 1
    }
    return 0

}

function shape(Rx) {
    return a_real*exp(b_real*Rx) + c_real*exp(d_real*Rx)
}


BEGIN {
  lo=1; hi=2
  x=1; y=2; z=3
  inatoms=0
  iatom=0

}

/LAMMPS/{
  print
  next
}

/xlo xhi/{
  box[x,lo]=$1
  box[x,hi]=$2
}

/ylo yhi/{
  box[y,lo]=$1
  box[y,hi]=$2
}

/zlo zhi/{
  box[z,lo]=$1
  box[z,hi]=$2
}

/atom types/{
  # number of atoms types
  natom_type = $1
  # print a string with atom types 
  print
  next
}

/atoms/{
  natoms=$1
  print
  next
}

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

inatoms{
    # here I get one atom
    Rx=$3
    Ry=$4
    Rz=$5

    if (iswall(Rx, Ry, Rz)) {
	$2= wall_type
    }
    print
    next
}

!inatoms {
  print
  next
}

