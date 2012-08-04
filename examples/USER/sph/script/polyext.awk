#! /usr/bin/awk -f
# makes a polymer extension scatter plot
# <x, y, extension> 

function reset() {
    xcm=ycm=0
    nb=0
    xMax = -1e19
    xMin = 1e19
}

function output() {
    if (nb>0) {
	print xcm/nb, ycm/nb, (xMax-xMin)
    }
    reset()
}

BEGIN {
    reset()
}

NF{
  x = $1
  y = $2
    
  if (xMax<x) xMax=x
  if (xMin>x) xMin=x

  nb++
  xcm+=x
  ycm+=y
}

!NF {
    output()
}

END {
    output()
}