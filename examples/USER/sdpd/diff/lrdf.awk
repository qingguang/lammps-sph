/^#/ {
    next
}

NF==2 {
    n++
    next
}

n==nsnap && NF>2 {
    print $2, $3
}

n>nsnap{
    exit
}

