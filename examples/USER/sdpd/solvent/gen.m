c = logspace(1, 5, 10);
bg = linspace(0, 1, 10);
dlmwrite("bg.dat", bg', " ", "precision", "%4.2f")
dlmwrite("c.dat", c', " ", "precision", "%6.2e")
