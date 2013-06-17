eta=1.5e-2
rho=1e3
Ly=1.802e-3
L=0.25*Ly
f=6.12
vmax = f/(2*eta/rho)*L*L
print vmax
Re = vmax*2.0*L/(eta/rho)
print Re
