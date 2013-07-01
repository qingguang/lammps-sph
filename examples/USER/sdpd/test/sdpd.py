from lammps import lammps
lmp = lammps()
lmp.file("sdpd_3part_3d.lmp")

# equal style variable
h=lmp.extract_variable("h", None, 0)
print h

# 
natoms=lmp.extract_global("natoms", 0)
print natoms

mass = lmp.extract_atom("mass",2)
print mass[1]

f = lmp.extract_atom("f",3)
print f[1][1]
