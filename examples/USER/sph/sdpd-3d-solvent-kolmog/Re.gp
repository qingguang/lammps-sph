
F=20
dx=2.5e-5
sdpd_rho=1e3
sdpd_mu=1.5e-5
sdpd_mass=dx**3*sdpd_rho
kb=1.3806503e-23
T=1e9
vt=(3*kb*T/sdpd_mass)**0.5
L=2.5e-4

ky=2*3.141592653/L
v0=F/(sdpd_mu*ky**2)
Res=F/(sdpd_mu**2*ky**3)
Re=v0*L/sdpd_mu
print "Maxiaml Velocity: ", v0
print "thermal velocity:",vt
print  "stablity threshold:",Res
print "Renold number: ", Re
