proc @ {} {
    concat
}


set sel_all [atomselect top "all"]
set reslist [$sel_all get resid]; @

foreach l $reslist {
    set a($l) 1
}
set reslist [ array names a ]; @

foreach res $reslist {
    set sel_res [atomselect top "resid ${res}"]
    animate write xyz data.xyz.${res} sel $sel_res 0
    exec "awk" "-f" "../script/xyz2punto.awk" "data.xyz.$res" ">" "data.punto.$res"
}

