# a saver script for gnuplot
# See sexample.gp
#set term push
#set term postscript eps enhanced color
#set output sprintf("%s.eps", "energy-spectra-4RF-2D-6BeadPolymer-96*96")
#replot

set terminal png
<<<<<<< HEAD
set output sprintf("%s.png", "Ek-2D-solvent-64*64-decay-time")
=======
set output sprintf("%s.png", "Ek-2D-solvent-32*32-Re0.2")
>>>>>>> c969a01d75d1e28407ff46035f72e224ea6fa54a
replot
set output

#set term pop
#replot
