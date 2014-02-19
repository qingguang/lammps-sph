n = [3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0];
c = (n./4.0).^3 * 10
dlmwrite("n.dat", n', " ", "precision", "%.2f")
dlmwrite("c.dat", c', " ", "precision", "%2.2f")

