# a saver script for gnuplot
# See sexample.gp
#set term push
#set term postscript eps enhanced color
#set output sprintf("%s.eps", "$0")
#replot

set terminal png
set output sprintf("%s.png", "single-10-bead-polymer-PAF(t)-loglog")
replot
set output

set term pop
replot
