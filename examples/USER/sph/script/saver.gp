# a saver script for gnuplot
# See sexample.gp
set term push
set term postscript eps enhanced color
set output sprintf("%s.eps", "$0")
replot

set terminal png
set output sprintf("%s.png", "polymer_kolmo_spectra_Re0.874_Wi2.62")
replot
set output

set term pop
replot
