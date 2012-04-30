
dx=2.5e-5
sdpd_c=3e-1
sdpd_rho=1e3
sdpd_mu=1.5e-5
sdpd_mass=dx**3*sdpd_rho

kb=1.3806503e-23
T=1e14
vt=(3*kb*T/sdpd_mass)**0.5

L=20*dx
tau=0.1144


H=55
r0=2.0*dx
pc=H*r0**2/(kb*T)


print "thermal velocity:",vt
print "polymer Hr0^2/kbT :",pc
