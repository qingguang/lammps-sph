set size 0.7
rdf(k, n, nf)=sprintf("<awk -v nf=%s -f lrdf.awk c1.0-temp0.00-gamma1.00-eta1e-3-background0.00-nx30-n%s-ktype%s-grid0/lrdf.dat", nf, n, k)

f(tr, n, k)=system(sprintf("awk -v tr=%s '$13<tr&&NR>3{print NR; exit}' c1.0-temp0.00-gamma1.00-eta1e-3-background0.00-nx30-n%s-ktype%s-grid0/prints/moments_all.dat", tr, n, k))


tr="1.0e-3"
#k="wendland6"
k="laguerrewendland4eps"
#k="quintic"
set xlabel "r/dx"
set ylabel "RDF"
set macros
dx=1.2/30.0
u='u ($1/dx):2 t n w l lw 2'
plot [:3.3][:5] \
     n="3.0", rdf(k, n, f(tr, n, k)) @u, \
     n="3.5", rdf(k, n, f(tr, n, k)) @u, \
     n="4.0", rdf(k, n, f(tr, n, k)) @u, \
     n="4.5", rdf(k, n, f(tr, n, k)) @u, \
     n="5.0", rdf(k, n, f(tr, n, k)) @u, \
     n="5.5", rdf(k, n, f(tr, n, k)) @u lc 7

call "saver.gp" "lrdf"     
