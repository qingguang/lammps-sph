set terminal postscript
set output "3Dpolymer.ps"
replot
set output              # set output back to default
set terminal x11        # ditto for terminal type
! lp -ops 3Dpolymer.ps        # print PS File (site dependent)

