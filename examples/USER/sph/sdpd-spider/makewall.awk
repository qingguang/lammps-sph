function fabs(var) {
  return var>0?var:-var
}

function iswall(Rx, Ry) {
    Lx = box[x,hi]-box[x,lo]
    Ly = box[y,hi]-box[y,lo]
    xd_real = xd * Lx
    a_real = a * xd_real
    c_real = Ly/2 - a_real
    b_real = b/xd_real
    d_real = d/xd_real
    
    # move to the center
    Ry = fabs(Ry - Ly/2)

    if (Rx<xd_real)  {
	# initial
	return Ry>shape(Rx)
    } else if (Rx< Lx - xd_real) {
	# transition
	return Ry>shape(xd_real)
    } else {
	return Ry>shape(Lx-Rx)
    }

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

    if (iswall(Rx, Ry)) {
	$2= wall_type
    }
    print
    next
}

!inatoms {
  print
  next
}

