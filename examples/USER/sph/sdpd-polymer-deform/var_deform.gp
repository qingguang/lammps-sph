eta=1.5e-2
rho=1e3
dx=2.5e-5
Ly=20*dx
deform_rate=50
vmax =deform_rate*Ly/2
print vmax
Re = vmax*Ly/(eta/rho)
print Re
