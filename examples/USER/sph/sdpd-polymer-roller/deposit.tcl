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

mol modselect 0 0 name polymer
color Display Background white
color Name S blue

color Axes Labels blue

mol representation Lines 3.000000

mol addrep 0
mol modselect 1 0 name polymer
mol modstyle 1 0 VDW 0.500000 12.000000

set xt 0.2
set yt 0.15
# contraction starts at
set xcmin [expr {${Lx} * 0.5 * (1-${xt})}]
set ycmin [expr {${Ly} * 0.5 * (1-${yt})}]

set xcmax [expr { ${xcmin} + ${Lx}*${xt}}]
set ycmax [expr { ${ycmin} + ${Ly}*${yt}}]


pbc join resid -all  -verbose -sel "name polymer"

# after 4000
# set num 41
# for {set i 0} {$i < $num} {incr i} {
#     # go to the given frame
#     animate goto $i
#     set filename snap.[format "%04d" $i].rgb
#     render snapshot $filename
# }
