F=40
dim=2

dx=2.5e-5
sdpd_c=20
sdpd_rho=1000.0
sdpd_eta=3e-2
sdpd_mu=sdpd_eta/sdpd_rho
sdpd_mass=(dx**dim)*sdpd_rho

kb=1.3806503e-23
T=1e12
vt=(3*kb*T/sdpd_mass)**0.5

L=48*dx
tau=0.1144

ky=2*3.141592653/L
v0=F/(sdpd_mu*ky**2)
#H=5.3e-4
#r0=2.0*dx
#pc=H*r0**2/(kb*T)

Ma=v0/sdpd_c
#Res=F/(sdpd_mu**2*ky**3)
Re=v0*L/sdpd_mu
Wi=tau*v0/L

#vrm=0.02433
#vrm = 0.02277
#vrm=0.01818
vrm = 0.01801
eta=sdpd_rho*F/(vrm*ky**2)
#Rer=vrm*L/sdpd_mu
#Wir=tau*vrm/L

print "Maxiaml Velocity: ", v0
print "thermal velocity:",vt
print "velocity/Cs: ",v0/sdpd_c
print "l/c-divided-l2/sdpd_mu:",L/sdpd_c/(L**2/sdpd_mu)
print "Mach number is:",Ma
print "Renold number theory: ", Re
print "output eta is: ",eta
#print "Weissenberg number theory:",Wi
#print "Renold number real : ", Rer
#print "Weissenberg number real :",Wir
#print "polymer Hr0^2/kbT :",pc
