BEGIN {
    xidx=2; yidx=3; zidx=4
}

NR==2{
    x0=$(xidx); y0=$(yidx); z0=$(zidx)
}

NR>1{
    $(xidx)=$(xidx)-x0
    $(yidx)=$(yidx)-y0
    $(zidx)=$(zidx)-z0
    print
}
