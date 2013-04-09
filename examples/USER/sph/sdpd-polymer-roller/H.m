H = linspace(1.00e-04, 2.15e-03, 5);
dlmwrite("H.dat", H', "delimiter", " ", "precision" , "%9.2e")

c = linspace(4.64e-02, 4.64e-01, 5);
dlmwrite("c.dat", c', "delimiter", " ", "precision" , "%9.2e")