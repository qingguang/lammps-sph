function fabs(var) {
  return var>0?var:-var
}

# returns true if there is a bound [atom_number, atom_number + 1]
# uses iatom
function isbound(atom_number,       period, rem, current_npoly) {
  period = Nbeads + Nsolvent
  rem = (atom_number-1)%(period) # from 0 to period-1
  current_npoly = int(atom_number/period) + 1
  return (rem<Nbeads-1) && (current_npoly<=Npoly)
}

BEGIN {
  inatoms=0
  lo=1; hi=2
  x=1; y=2; z=3
  iatom=0
  if (Npoly=="full") {
    Npoly = 1e22
  }
}

/LAMMPS/{
  print
  next
}

/xlo xhi/{
  box[x,lo]=$1
  box[x,hi]=$1
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

  print "1 bond types"
  next
}

/atoms/{
  natoms=$1
  print
  printf("%s bonds\n", "_NUMBER_OF_BOUNDS_")
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
  iatom++
  R[x]=$4; R[y]=$5; R[z]=$6
  if (iatom>1) {
    for (idim=1; idim<=3; idim++) {
      if (fabs(R[idim]- prevR[idim])>cutoff) {
        if (R[idim]<prevR[idim]) image[idim]++; else image[idim]--
      }
    }
  } else {
    image[x]=0; image[y]=0; image[z]=0
  }
  prevR[x]=R[x]; prevR[y]=R[y]; prevR[z]=R[z]
  # change image field
  $(NF-2)=image[x]; $(NF-1)=image[y];   $(NF)=image[z];

  # if atom has a bound we change atom type to natoms_type
  if ( isbound($1) ) {
      $2 = natom_type
  }
  if ( ($1>1) && isbound($1-1) ) {
      $2 = natom_type
  }
  print $0
  next
}

!inatoms {
  print
  next
}

END {
  printf("\nBonds\n\n")
  ibond = 0
  for (q=1; q<iatom; q++) {
    if (isbound(q)) {
      ibond++
      ip = q
      jp = q+1
      bondtype=1
      print ibond, bondtype, ip, jp
    }
  }
}
