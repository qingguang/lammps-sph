sdpd_c = logspace(0.5, 3, 10);
n = linspace(3.0, 5.0, 10);
nx = [50, 100];
dlmwrite("sdpd_c.dat", sdpd_c', " ", "precision", "%6.2e")
dlmwrite("n.dat", n', " ", "precision", "%6.2e")
dlmwrite("nx.dat", nx', " ", "precision", "%i")
