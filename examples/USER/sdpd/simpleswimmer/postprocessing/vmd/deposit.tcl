# vmd -psf poly3d.psf  -dcd /scratch2/work/lammps-sph/examples/USER/sph/sdpd-polymer-fedosov/poly3d.dcd  -e makemol.tcl
log ~/vmd.tcl
user add key q exit

set Lx 12
set minx 0.40
set maxx [expr ${Lx}-${minx}]
atomselect macro inregion "x>${minx} and x<${maxx} and y>${minx} and y<${maxx}"

set sel [atomselect top all]
$sel set radius 0.03

set solvent [atomselect top "type 1"]
$solvent set radius 0.03
$solvent set name B
color        Name B red

set polymers [atomselect top "type 4"]
$polymers set radius 0.03
$polymers set name  O
color        Name O blue

set swimmer [atomselect top "type 2"]
$swimmer set radius 0.03
$swimmer set name  H
color        Name H green

set swimmerhead [atomselect top "type 3"]
$swimmerhead set radius 0.06
$swimmerhead set name  S
color        Name S cyan

mol modselect 0 0 type 4 or type 3 or type 2 or type 1
mol modstyle 0 0 VDW 1.000000 15

color Display Background white
axes location off

set pb [list ${Lx} ${Lx} ${Lx}]
pbc set ${pb} -all

pbc join resid

mol selection all
mol modselect 0 0 all
mol addrep 0
mol modstyle 1 0 Bonds 0.300000 10.000000
mol modstyle 1 0 Lines 2

proc mycut {} {
    mol modselect 0 0 inregion
    mol modselect 1 0 inregion
}

proc onlypol {pid} {
    mol modselect 0 0 resid ${pid}
    mol modselect 1 0 resid ${pid} 
}

proc lrender {}  {
    render Tachyon vmdscene.dat "/scratch/netbsd/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA -o %s.tga
    exec convert vmdscene.dat.tga rend/vmd.[clock seconds].png
}

#mycut
user add key w lrender

scale by 1.002000
scale by 1.238000
scale by 1.005000
scale by 1.004000
scale by 1.296000
scale by 1.001000
scale by 1.173000
scale by 0.999000
scale by 0.988000
scale by 0.993000
