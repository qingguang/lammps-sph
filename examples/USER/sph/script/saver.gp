# a saver script for gnuplot
# See sexample.gp
#set term push
set term postscript eps enhanced color
set output sprintf("%s.eps", "spesols")
replot

set terminal png
set output sprintf("%s.png", "solvent_v3e-2_Re0.75")
replot
set output

#set term pop
#replot
