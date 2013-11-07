#function fabs(var) {
#  return var>0?var:-var
#}

function isbond(atom_number,        period, rem, current_npoly) {
    if (atom_number>=natoms) return 0;
    if (atom_number<=Nbeadsinswimmer) return 0;


    period = Nbeads + Nsolvent
    rem = (atom_number-1)%(period) # from 0 to period-1
    current_npoly = int(atom_number/period) + 1
    return (rem<Nbeads-1) && (current_npoly<=Npoly)
}

BEGIN {
  inatoms=0
  lo=1; hi=2
  x=1; y=2; z=3
  swimmeratomtype=2
  swimmerbondtype=1
  
  polymerbondtype=2
  polymeratomtype=3

  if (Npoly=="full") Npoly=1e30
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
  print
  print "2 bond types"
  printf "%i angle types\n", Nbeadsinswimmer - 2
  next
}

/atoms/{
  natoms=$1
  print
  printf "%s bonds\n",  "_NUMBER_OF_BOUNDS_"
  printf "%i angles\n", Nbeadsinswimmer - 2

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
  id = $1
  if (id<=Nbeadsinswimmer) {
      $2=swimmeratomtype
  }
  if (isbond(id) || isbond(id-1) ) {
     $2=polymeratomtype
  }
  print
  next
}

!inatoms {
  print
  next
}

END {
  printf "\nBonds\n\n"

  # add bonds for a swimmer
  ibond = 0
  for (q=1; q<Nbeadsinswimmer; q++) {
      ibond++
      ip = q
      jp = q+1
      print ibond, swimmerbondtype, ip, jp
 }

 # add bonds for polymers
  for (q=1; q<natoms; q++) {
    if (isbond(q)) {
      ibond++
      ip = q
      jp = q+1
      print ibond, polymerbondtype, ip, jp
    } 
 }

 printf("\nAngles\n\n")
 iangle = 0
 iangletype = 0
 for (q=1; q<Nbeadsinswimmer-1; q++) {
     ia = q
     ja = q+1
     ka = q+2
     iangle++
     iangletype++
     # number of angle, type of angle, three atoms to form an angle
     print iangle, iangletype, ia, ja, ka
 }
}
