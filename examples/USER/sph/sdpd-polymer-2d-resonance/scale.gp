
dx=2.5e-5
sdpd_c=1
sdpd_rho=1e3
sdpd_mu=1e-7
sdpd_eta=sdpd_rho*sdpd_mu
sdpd_mass=dx**3*sdpd_rho

kb=1.3806503e-23
T=1e14
vt=(3*kb*T/sdpd_mass)**0.5

L=32*dx
tau=0.1144


H=55
r0=2.0*dx
pc=H*r0**2/(kb*T)
#D=0.000236326104358432/(sdpd_mu/1.5e-5)/2
D=0.0011872
K=8e4*sdpd_mass
R_h=kb*T/(6*pi*sdpd_eta*D)
R_g2=1.2e-7
MSDinf=2*kb*T/K
gamma=6*pi*sdpd_eta*R_h
tau_p=sdpd_mass/gamma
tau_f=R_h**2*sdpd_rho/sdpd_eta
tau_k=gamma/K
tau_c=R_h/sdpd_c
tau_d=R_g2/D

print D
print "MSD(inf): ",MSDinf
print "MSDInf/R_g2 is: ",MSDinf/R_g2
print "thermal velocity:",vt
print "polymer Hr0^2/kbT :",pc
print "polymer tau_c :",tau_c
print "polymer tau_p :",tau_p
print "polymer tau_f :",tau_f
print "polymer tau_k :",tau_k
print "polymer tau_d :",tau_d
print "polymer tau_k/tau_f :",tau_k/tau_f
