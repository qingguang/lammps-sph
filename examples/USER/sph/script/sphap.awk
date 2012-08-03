#! /usr/bin/aawk -f

function kernel(r,               q,  k, w) {
    pi = 3.1415926
    k=10/(7*pi)
    q = 2*abs(r)/cutoff
    if (q<1) {
	w = 1 - 3*q^3/2 + 3*q^3/4
    } else if (q<2) {
	w = (2-q)^3/4
    } else {
	w = 0
    }
    return k*w
}

function test_kernel(i, n, x) {
    n=100
    for (ix=-n; ix<=n; ix++) {
	r=cutoff*ix/n
	print r, kernel(r)
    }
}

function abs(x) {
    if (x>0) {
	return x
    } else {
	return -x
    }
}

function round(x,   ival, aval, fraction)
{
    ival = int(x)    # integer part, int() truncates
    
    # see if fractional part
    if (ival == x)   # no fraction
	return ival   # ensure no decimals
    
    if (x < 0) {
	aval = -x     # absolute value
	ival = int(aval)
	fraction = aval - ival
	if (fraction >= .5)
	    return int(x) - 1   # -2.5 --> -3
	else
	    return int(x)       # -2.3 --> -2
    } else {
	fraction = x - ival
	if (fraction >= .5)
	    return ival + 1
	else
	    return ival
    }
}

function info() {
    print "Lx: " int(Lx/gstep) > "/dev/stderr"
    print "Ly: " int(Ly/gstep) > "/dev/stderr"
    print "xidx: " xidx > "/dev/stderr"
    print "yidx: " yidx > "/dev/stderr"
}

function oneparticle(x, y)  {
    # grid position
    ix0=int(x/gstep)
    iy0=int(y/gstep)
    
    for (ix=ix0-dg; ix<=ix0+dg+1; ix++) {
	for (iy=iy0-dg; iy<=iy0+dg+1; iy++) {
	    gx = ix*gstep
	    gy = iy*gstep
	    r = sqrt( (x-gx)^2 + (y-gy)^2 )
	    w = kernel(r)
	    for (ip=3; ip<=NF; ip++) {
		val[ip, ix, iy]+=  w * $(ip)
	    }
	    np[ix, iy]+= w
	}
    }
}


# SPH approximation from particles to the grid
BEGIN {
    # domain size
    if (!Lx) {
	Lx=0.0166667
    }
    
    if (!Ly) {
	Ly=0.0166667
    }
    
    if (!xidx) {
	xidx=1
    }

    if (!yidx) {
	yidx=2
    }

    
    # kernel parameters
    dx=8.333333e-4
    m=2.7
    cutoff = m*dx
    
    # grid step
    gstep=2.0*dx
    dg = round(gstep/cutoff)

    if (test_kernel_flag) {
	test_kernel()
	stop()
    }

    info()

}

ns>15 {
    if (nfield<NF) nfield=NF
    x=$(xidx)
    y=$(yidx)
    
    for (dx=-1; dx<=1; dx++) {
	for (dy=-1; dy<=1; dy++) {
	    oneparticle(x+dx*Lx, y+dy*Ly)
	}
    }
}

!NF {
    ns++
    printf("ns: %i\n", ns) > "/dev/stderr"
}

END {
    for (ix=0; ix<=int(Lx/gstep)+1; ix++) {
	for (iy=0; iy<=int(Ly/gstep)+1; iy++) {
	    gx = ix*gstep
	    gy = iy*gstep
	    printf("%e %e ", gx, gy)
	    for (ip=3; ip<=nfield; ip++) {
		if (np[ix, iy]>0) {
		    printf("%e ", val[ip, ix, iy]/np[ix, iy])
		} else {
		    printf("%e ", 0.0)
		}
	    }
	    print
	} 
    }
}