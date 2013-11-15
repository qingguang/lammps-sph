set xlabel "time step"
set ylabel "displacement"
set term x11 1

#f="supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave150-dsize150mass3/prints/msd.dat"
#fit [:50.0] f(x) via a, b
set macro
limit='[:10.0][:5.0]'

plot  @limit \
     "supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave450-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave150-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave50-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave10-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads0-nsolvent20-K_wave500-T_wave20-v_wave2-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l

set term x11 2
plot @limit \
     "supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave450-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave150-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave50-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave10-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent5-K_wave500-T_wave20-v_wave2-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l

set term x11 3
plot @limit \
     "supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave450-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave150-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave50-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave10-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l, \
     "supermuc-data/c3e2-nbeads10-nsolvent20-K_wave500-T_wave20-v_wave2-dsize150mass3/prints/msd.dat" u 1:(sqrt($2)) w l

     
     
