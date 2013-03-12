# vmd -psf poly3d.psf  -dcd /scratch2/work/lammps-sph/examples/USER/sph/sdpd-polymer-fedosov/poly3d.dcd  -e makemol.tcl
log ~/vmd.tcl

# to supress output
proc @ {} {
    concat
}

set sel_solvent [atomselect top "name 1"]
$sel_solvent set name sol

set sel_polymer [atomselect top "name 2"]
$sel_polymer set name polymer

set sel_wall [atomselect top "name 4"]
$sel_wall set name wall


# domain size from lammps configuration file
set Lx 0.25
set Ly 0.0533333
set Lz 0.01

# dx for particle placing
set dx 8.333333e-4

set sel [atomselect top all]
$sel set radius ${dx}

set xmin [expr 2*${dx}]
set xmax [expr $Lx-2*${dx}]

set ymin [expr 2*${dx}]
set ymax [expr $Ly-2*${dx}]

set zmin [expr 2*${dx}]
set zmax [expr $Lz-2*${dx}]

proc makeS {sstring} {
    [atomselect top "name S"] set name polymer
    set small [atomselect top ${sstring}]
    $small set name S
}

set sstring "x>${xmin} and x<${xmax} and y>${ymin} and y<${ymax} and z>${zmin} and z<${zmax} and name polymer"
user add key n {animate next; makeS $sstring}
user add key p {animate prev; makeS $sstring}

mol modselect 0 0 name polymer
color Display Background white
color Name S blue

color Axes Labels blue

set xt 0.2
set yt 0.15
# contraction starts at
set xcmin [expr {${Lx} * 0.5 * (1-${xt})}]
set ycmin [expr {${Ly} * 0.5 * (1-${yt})}]

set xcmax [expr { ${xcmin} + ${Lx}*${xt}}]
set ycmax [expr { ${ycmin} + ${Ly}*${yt}}]

draw color red
set lw 3
foreach xl [list ${xcmin} ${xcmax}] {
    foreach zl [list 0 ${Lz}] {
	draw line "${xl} 0 ${zl}" "${xl} ${ycmin} ${zl}" style solid width ${lw}
	draw line "${xl} ${ycmax} ${zl}" "${xl} ${Ly} ${zl}" style solid width ${lw}
    }
}

foreach xl [list 0 ${Lx}] {
    foreach zl [list 0 ${Lz}] {
	draw line "${xl} 0 ${zl}" "${xl} ${Ly} ${zl}" style solid width ${lw}
    }
}

foreach yl [list ${ycmin} ${ycmax}] {
    foreach zl [list 0 ${Lz}] {
	draw line "${xcmin} ${yl} ${zl}" "${xcmax} ${yl} ${zl}" style solid width ${lw}
    }
}

foreach yl [list 0 ${Ly}] {
    foreach zl [list 0 ${Lz}] {
	draw line "0 ${yl} ${zl}" "${xcmin} ${yl} ${zl}" style solid width ${lw}
	draw line "${xcmax} ${yl} ${zl}" "${Lx} ${yl} ${zl}" style solid width ${lw}
    }
}

foreach xl [list ${xcmin} ${xcmax}] {
    foreach yl [list ${ycmin} ${ycmax} 0 ${Ly}] {
	draw line "${xl} ${yl} 0" "${xl} ${yl} ${Lz}" style solid width ${lw}
    }
}

foreach xl [list 0 ${Lx}] {
    foreach yl [list 0 ${Ly}] {
	draw line "${xl} ${yl} 0" "${xl} ${yl} ${Lz}" style solid width ${lw}
    }
}

user add key n {animate next; makeS $sstring}
user add key p {animate prev; makeS $sstring}
