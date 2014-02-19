function fabs(x) {
    if (x>0) {return x} else {return -x}
}

{
    err+=fabs($(xidx)-$(yidx))
    n++
} 

END {print err/n}
