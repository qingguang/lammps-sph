BEGIN {
  inatoms=0
  lo=1; hi=2
  x=1; y=2; z=3
  swimmerbeadtype=2
  swimmerbondtype=1
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
  print "1 bond types"
  printf "%i angle types\n", Nbeadsinswimmer - 2
  next
}

/atoms/{
  natoms=$1
  print
  printf("%i bonds\n",  Nbeadsinswimmer - 1)
  printf("%i angles\n", Nbeadsinswimmer - 2)

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
      $2=swimmerbeadtype
  }
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
  for (q=1; q<Nbeadsinswimmer; q++) {
      ibond++
      ip = q
      jp = q+1
      print ibond, swimmerbondtype, ip, jp
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
