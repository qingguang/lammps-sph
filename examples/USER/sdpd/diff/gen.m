sdpd_c = logspace(-1, 5, 20);
n = linspace(2.5, 5.0, 10);
dlmwrite("sdpd_c.dat", sdpd_c', " ", "precision", "%6.2e")
dlmwrite("n.dat", n', " ", "precision", "%6.2e")
