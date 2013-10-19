sdpd_c = logspace(1, 5, 10);
n = linspace(3.0, 5.0, 6);
eta = linspace(1, 4, 2);
dlmwrite("sdpd_c.dat", sdpd_c', " ", "precision", "%6.2e")
dlmwrite("n.dat", n', " ", "precision", "%6.2e")
dlmwrite("eta.dat", eta', " ", "precision", "%6.2e")

