grid = [0, 1];
n = linspace(3.5, 5.5, 10);
dlmwrite("n.dat", n', " ", "precision", "%6.2e")
dlmwrite("grid.dat", grid', " ", "precision", "%1.0f")

