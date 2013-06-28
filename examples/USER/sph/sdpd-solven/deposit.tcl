# read lammps files with "fix deposit"
log vmd.tcl
user add key q exit

#topo readlammpsdata poly3d.txt


# read variable number of atoms
#topo readvarxyz [lindex $argv 0]
#animate read psf poly3d.psf

#mol modstyle 0 0 Points 16
set Lx 5e-2
set nx 50
set dx [expr 3*${Lx}/${nx}]

set pb [list ${Lx} ${Lx} ${Lx}]
pbc set ${pb} -all

set sel [atomselect top all]
$sel set radius 0.018

#mol modstyle 0 0 VDW 0.600000 15.000000

#color Display Background white
#color Display FPS black
#color Axes Labels black
axes location off

proc remove_long_bonds { max_length } {
     for { set i 0 } { $i < [ molinfo top get numatoms ] } { incr i } {
         set bead [ atomselect top "index $i" ]
         set bonds [ lindex [$bead getbonds] 0 ]

         if { [ llength bonds ] > 0 } {
             set bonds_new {}
             set xyz [ lindex [$bead get {x y z}] 0 ]

             foreach j $bonds {
                 set bead_to [ atomselect top "index $j" ]
                 set xyz_to [ lindex [$bead_to get {x y z}] 0 ]
                 if { [ vecdist $xyz $xyz_to ] < $max_length } {
                     lappend bonds_new $j
                 }
             }
             $bead setbonds [ list $bonds_new ]
         }
     }
} 

molinfo top get numframes

set x1 [expr ${dx}]
set x2 [expr ${Lx}-${dx}]
set y1 [expr ${dx}]
set y2 [expr ${Lx}-${dx}]
#mol modselect 0 0 all and x>$x1 and x<$x2 and y>$y1 and y<$y2

pbc box

# set n [molinfo top get numframes]
# for { set i 0 } { $i < $n } { incr i } {
#     $sel frame $i
#     animate goto $i
#     $sel update
#     puts "processing frame: $i"
#     remove_long_bonds [expr 0.5*${Lx}]
# }

