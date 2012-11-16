function fabs(var) {
  return var>0?var:-var
}

function iswall(Rx, Ry, Rz) {
    Lx = box[x,hi]-box[x,lo]
    Ly = box[y,hi]-box[y,lo]
    Lz = box[z,hi]-box[z,lo]
    # size of gland geometry
    xt_real = xt* Lx
    # size of the buffer region at the initial part of the domain
    xb_real = xb * Lx
    a_real = a * xt_real
    c_real = Ly/2 - a_real
    b_real = b/xt_real
    d_real = d/xt_real
    
    #
    # |--- buffer (xb) ---|--- gland (xt) ---|--- channel ---|--- gland (xt) ---|
    # 

    R = sqrt((Ry - Ly/2)^2 + (Rz - Lz/2)^2)

    # external wall (3 layers of particles)
    if (R > (Ly/2 - 2*dx) ) {
	return 1
    }

    # the buffer region
    if (Rx<xb_real) {
	return 0
    }
    
    if (Rx<xt_real+xb_real)  {
	# initial
	return R>shape(Rx-xb_real)
    } else if (Rx< Lx - xt_real) {
	# transition, tube, constant radii
	return R>shape(xt_real)
    } else {
	# end of the domain
	return R>shape(Lx-Rx)
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

