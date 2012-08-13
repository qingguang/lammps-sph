rm projection.*
rm spectra.dat
for filename in dump*.dat; do echo $filename;  
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
awk 'fl{print $3, $4, $6, $7} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
#./zs_mls_projection 2 32 0.0267 1.7 ${filename/.dat/.del} 2 2 2 ;
./zs_mls_projection 2 128 0.107 2.0 ${filename/.dat/.del} 2 2 2 ;
done
#awk 'fl{print $3, $4, $5, $6,$7,$8} /ITEM: ATOMS/{fl=1}' dump0*.dat > projection*.dat
#./zs_mls_projection 3 20 1 1.8 dump*.del 2 2 2
#octave --eval Spectra.m
octave --eval Spectra2D.m


