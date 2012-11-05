rm projection.*
rm spectra.dat

for filename in dump*.dat; do echo $filename;  
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
awk 'fl{print $3, $4, $6, $7} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
./zs_mls_projection 2 64 0.0534 2.0 ${filename/.dat/.del} 2 2 2 ;
done
octave --eval Spectra2D.m


