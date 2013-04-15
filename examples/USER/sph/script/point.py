# For emacs set
# (setenv "PYTHONPATH" "/scratch/work/Pizza.py/src/")
# (setenv "PYTHONPATH" "/home/vital303/work/Pizza.py/src/")

import dump
import numpy as np

d = dump.dump("dump*.dat")

Lx = 0.426665
xp = 5.0/8.0 * Lx
yp = 5.0/8.0 * Lx

x1 = xp*0.95
x2 = xp*1.05
y1 = yp*0.95
y2 = yp*1.05

d.tselect.all()
t = d.time()

vpoint = np.zeros([np.size(t), 2])
i = 0
for tc in t:
    x = np.array(d.vecs(tc, "x"))
    y = np.array(d.vecs(tc, "y"))
    vx = np.array(d.vecs(tc, "vx"))
    vy = np.array(d.vecs(tc, "vy"))
    idx = (x>x1) & (y>y1) & (x<x2) & (y<y2)
    vpoint[i, 0] = np.mean(vx[idx])
    vpoint[i, 1] = np.mean(vy[idx])
    i = i + 1
    np.savetxt("vpoint.dat", np.column_stack( (t, vpoint) ))

#np.savetxt("vom.dat", np.column_stack( (t, vom) ))

