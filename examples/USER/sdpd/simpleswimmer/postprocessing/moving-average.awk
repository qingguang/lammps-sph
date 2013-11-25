#!/usr/bin/awk -f
# Moving average over the first column of a data file 
BEGIN {
    P = 100
}
 
{ 
    t = $(tidx)
    x = $(xidx)
    i = NR % P

    MA += (x - Z[i]) / P
    Z[i] = x

    print t, MA
}