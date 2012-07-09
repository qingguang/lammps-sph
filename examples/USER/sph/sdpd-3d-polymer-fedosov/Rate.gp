Ly=1.803e-3
L=Ly/2
V=0.035
Ra=V/L
f=6.12
eta=1.5e-5
va=f*(L**2/4)/(2*eta)
etas=f*(L**2/4)/(2*V)
print "shear rate:", Ra
print "simulation velocity:",V
print "analytical velocity:",va
print "simulation eta:",etas
