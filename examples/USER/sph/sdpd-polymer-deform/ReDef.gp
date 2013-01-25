df_rate=8e2

dx=2.5e-5
sdpd_c=10
sdpd_rho=1e3
sdpd_eta=1.5e-2
sdpd_mu=1.5e-5
sdpd_mass=dx**3*sdpd_rho

kb=1.3806503e-23
T=1e9
vt=(3*kb*T/sdpd_mass)**0.5

L=40*dx

tau=0.1144

H=5.3e-4
r0=2*dx
pn=H*r0**2/(kb*T)

v0=df_rate*L/2
shear=sdpd_mu*df_rate/2;
Ma=v0/sdpd_c
#Res=F/(sdpd_mu**2*ky**3)
Re=2*v0*L/sdpd_mu

Wi=tau*v0*2/L
El=tau*sdpd_mu/(L*L)

print "Maxiaml Velocity: ", v0
print "thermal velocity: ",vt
print "Mach number is: ",Ma
print "shear stress is ; ",shear
#print "Renold number: ", Re
#print "Weissenberg number: ", Wi
#print "Elasticity  number: ", El
#print "polymerHr02/kT number is: ",pn
