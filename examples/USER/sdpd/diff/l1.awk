function fabs(x) {
    if (x>0) {return x} else {return -x}
}

(NF>=xidx) && (NF>=yidx) {
    err+=fabs($(xidx)-$(yidx))
    n++
} 

END {print err/n}
