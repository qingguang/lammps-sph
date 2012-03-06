F=20
sdpd_mu=1.5e-5
L=5e-4
ky=2*3.141592653/L
v0=F/(sdpd_mu*ky**2)
Res=F/(sdpd_mu**2*ky**3)
Re=v0*L/sdpd_mu
print "Maxiaml Velocity: ", v0
print  "stablity threshold:",Res
print "Renold number: ", Re
