rm projection.*
rm spectra.dat

for filename in dump*.dat; do echo $filename;  
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
awk 'fl{print $3, $4, $6, $7} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
<<<<<<< HEAD
./zs_mls_projection 2 128 0.107 2.0 ${filename/.dat/.del} 2 2 2 ;
=======
./zs_mls_projection 2 32 0.0267 2.0 ${filename/.dat/.del} 2 2 2 ;
>>>>>>> a8c01cb3661fd8d208427fa684c6b3767d2287f2
done
octave --eval Spectra2D.m


