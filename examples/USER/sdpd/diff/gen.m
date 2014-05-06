n = [3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0];
eta = (n./3.0).^(-6) * 1.00
# c  = ones(size(n)) * 4.2
dlmwrite("n.dat", n', " ", "precision", "%.2f")
dlmwrite("eta.dat", eta', " ", "precision", "%2.2f")

