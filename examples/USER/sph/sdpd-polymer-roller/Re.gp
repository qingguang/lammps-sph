F=1
dim=2

dx=2.5e-3/3
sdpd_c=10
sdpd_rho=1

#v0=0.26
sdpd_eta=3e-3*3
sdpd_mu=sdpd_eta/sdpd_rho
sdpd_mass=dx**dim*sdpd_rho

kb=1.3806503e-23
T=0
vt=(3*kb*T/sdpd_mass)**0.5

L=512*dx
tau=58

ky=2*3.141592653/(L/2)
v0=F/(sdpd_mu*ky**2)
v0=0.125
Ma=v0/sdpd_c
#Res=F/(sdpd_mu**2*ky**3)
Re=v0*L/sdpd_mu
Wi=tau*v0/L

print "Maxiaml Velocity: ", v0
print "thermal velocity:",vt
print "velocity/Cs: ",v0/sdpd_c
print "l/c-divided-l2/sdpd_mu:",L/sdpd_c/(L**2/sdpd_mu)
print "Mach number is:",Ma
print "Renold number theory: ", Re
print "Weissenberg number theory:",Wi
