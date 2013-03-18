# a saver script for gnuplot
# See sexample.gp
#set term push
set term postscript eps enhanced color
set output sprintf("%s.eps", "modified-sxxfullSub-syy-szz")
replot
#set output

set terminal png
set output sprintf("%s.png", "modified-sxxfullSub-syy-szz")
replot
set output

#set term pop
#replot
