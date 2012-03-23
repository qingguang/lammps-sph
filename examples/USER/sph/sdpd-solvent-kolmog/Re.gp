F=9
dx=2.5e-5

sdpd_c=3e-1
sdpd_rho=1e3
sdpd_mu=1.5e-6
sdpd_mass=dx**3*sdpd_rho

kb=1.3806503e-23
T=1e9
vt=(3*kb*T/sdpd_mass)**0.5

L=32*dx
tau=0.1144

ky=2*3.141592653/L
v0=F/(sdpd_mu*ky**2)

Ma=v0/sdpd_c
Mathermal=vt/sdpd_c
#Res=F/(sdpd_mu**2*ky**3)
Re=v0*L/sdpd_mu

Wi=tau*v0/L
vrm=0.023

Rer=vrm*L/sdpd_mu
Wir=tau*vrm/L
print "Maxiaml Velocity: ", v0
print "thermal velocity: ",vt

print "Mach number is: ",Ma
print "thermal Mach number is: ",Mathermal

print "Renold number theory: ", Re
print "Weissenberg number theory: ",Wi

print "Renold number real : ", Rer
print "Weissenberg number real :",Wir
