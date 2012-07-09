dim=3
Ly=1.803e-3
L=Ly/2
Ve=0.035
Ra=Ve/L
f=6.12
eta=1.5e-5
va=f*(L**2/4)/(2*eta)
etas=f*(L**2/4)/(2*Ve)
dx=2.5e-5
Vo=dx**dim
rho=1000
gx=6.2
sxy=gx * Vo * Ly / (4.0)*rho
print "shear rate: ", Ra
print "simulation velocity: ",Ve
print "analytical velocity: ",va
print "simulation eta: ",etas
print "maximal shear stress: ",sxy
