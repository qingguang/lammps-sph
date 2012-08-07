function trigerpolymer() {
    _triger_counter++
    if (_triger_counter%nextbond == 0) {
	return polymer_extbond
    } else {
	return polymer_normal
    }
}

function isbead(type) {
    if ( (type==polymer_normal) || (type==polymer_extbond) ) {
	return 1
    } else {
	return 0
    }
}

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

  print "1 bond types"
  print "1 angle types"
  next
}

/atoms/{
  natoms=$1
  print
  printf("%s bonds\n", "_NUMBER_OF_BOUNDS_")
  printf("%s angles\n", "_NUMBER_OF_ANGLES_")
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

  if (!($2 == wall_type)) {
      # if atom has a bound we change atom type to natoms_type
      if ( isbound($1) ) {
	  $2 = trigerpolymer()
      }
      if ( ($1>1) && isbound($1-1) ) {
	  $2 = trigerpolymer()
      }
  }
  # store a type of the atom
  type_array[$1]=$2
  print
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
      if (isbound(q) && ( isbead(type_array[q]) ) && ( isbead(type_array[q+1]) ) ) {
      ip = q
      jp = q+1
      bondtype=1
      ibond++
      print ibond, bondtype, ip, jp
    }
  }

  printf("\nAngles\n\n")
  iangle = 0
  for (q=1; q<iatom; q++) {
      if ( isbound(q) && isbound(q+1) &&
	   (isbead(type_array[q])) &&
	   (isbead(type_array[q+1])) && 
	   (isbead(type_array[q+2])) ) {
	  iangle++
	  angletype=1
	  # number of angle, type of angle, three atoms to form an angle
	  print iangle, angletype, q, q+1, q+2
      }
  }
}
