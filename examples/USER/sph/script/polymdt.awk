#! /usr/bin/awk -f
# shift polymer center of mass to the simulation domain
# <x, y, extension> 

function abs(x) {
    if (x>0) {
	return x
    }
    else {
	return -x
    }    
}


function reset() {
    xcm=ycm=0
    nb=0
}

function int_shift(R) {
    if (R>=0) {
	return int(R)
    } else {
	return int(R)-1
    }
}

BEGIN {
    if (length(Lx)==0) {
	printf "Lx must be given\n" > "/dev/stderr"
	exit(-1)
    }
    if (length(Ly)==0) {
	printf "Ly must be given\n" > "/dev/stderr"
	exit(-1)
    }
}

NF{
  x = $1
  y = $2
    
  if (xMax<x) xMax=x
  if (xMin>x) xMin=x

  nb++
  x_array[nb]=x
  y_array[nb]=y
  xcm+=x
  ycm+=y
}

!NF {
    xcm/=nb
    ycm/=nb

    x_shift = int_shift(xcm/Lx)*Lx
    y_shift = int_shift(ycm/Ly)*Ly

    for (i=1; i<=nb; i++) {
	x_center[i] = x_array[i]-x_shift
	y_center[i] = y_array[i]-y_shift
    }

    xprev=x_center[1]; xplus = 0
    yprev=y_center[1]; yplus = 0
    print xprev, yprev
    for (i=2; i<=nb; i++) {
	xc = x_center[i] + xplus
	yc = y_center[i] + yplus
	
	if ( abs(xc + Lx - xprev) < abs(xc - xprev) ) xplus+=Lx
	if ( abs(xc - Lx - xprev) < abs(xc - xprev) ) xplus-=Lx

	if ( abs(yc + Ly - yprev) < abs(yc - yprev) ) yplus+=Ly
	if ( abs(yc - Ly - yprev) < abs(yc - yprev) ) yplus-=Ly
	
	xprev = x_center[i] + xplus
	yprev =y_center[i] + yplus
	print xprev, yprev
    }

    printf("\n")
	     
    reset()
}