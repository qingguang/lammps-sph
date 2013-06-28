# gnuplot script to fit autocorrelation data
set macros
set key left
f(x) = x<0.5 ? vm*(x-0.25):vm*(0.75-x)
vm=4.366640625e-14*4;
file="<./lastvav.sh sxy.av"
file_with_u="file u 2:(-$4)"
fit [0:1] f(x) @file_with_u  via vm
plot [0:1] \
     f(x) t "imposed" w l ls 1, \
     @file_with_u t "calculated" w p pt 6 lt 1
