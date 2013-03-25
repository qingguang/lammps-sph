# vmd -dispdev text  -psf poly3d.psf dataNpoly-100Nbeads-80/wdump.dcd -e ../script/dcd2punto.tcl  -eofexit

set pdata pdata
set ncut 10
exec "mkdir" "-p" ${pdata}

proc @ {} {
    concat
}

proc molgyr {sel rgfile tensorfile} {
    set rp [open ${rgfile} w]
    set tp [open ${tensorfile} w]
    set numframes [molinfo 0 get numframes]
    for { set i 0 } { $i <= ${numframes} } {incr i} {
    $sel frame $i
	puts ${rp} [measure rgyr $sel]
	puts ${tp} [measure inertia $sel moments eigenvals]
    }
    close ${rp}
    close ${tp}
}


set sel_all [atomselect top "all"]
$sel_all set mass 1.0
set reslist [$sel_all get resid]; @

foreach l $reslist {
    set a($l) 1
}
set reslist [ array names a ]; @

foreach res $reslist {
    set sel_res [atomselect top "resid ${res} and name 2"]
    if  {[$sel_res num]>0} {
	molgyr ${sel_res} "${pdata}/rg.${res}" "${pdata}/tensor.${res}"
	animate write xyz ${pdata}/data.xyz.${res} beg ${ncut} sel $sel_res 0
	exec "awk" "-f" "../script/xyz2punto.awk" "${pdata}/data.xyz.$res" ">" "${pdata}/poly.$res"
    }
}

exit
