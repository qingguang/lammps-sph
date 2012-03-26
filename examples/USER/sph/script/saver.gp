# a saver script for gnuplot
# See sexample.gp
set term push
set term postscript eps enhanced color
set output sprintf("%s.eps", "$0")
replot

set terminal png
set output sprintf("%s.png", "solvent_kolmo_spectra_Re1_L2PI")
replot
set output

set term pop
replot
