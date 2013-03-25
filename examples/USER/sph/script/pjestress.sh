rm projection.*
rm spectra.dat
for filename in stress*.dat; do echo $filename;
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
#awk 'fl{print $3, $4, $6, $7} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
awk 'fl{print $1, $2, $4, $5} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
./zs_mls_projection 2 512 0.427 2.5 ${filename/.dat/.del} 2 2 2 ;
done
#./zs_mls_projection 3 20 1 1.8 dump*.del 2 2 2
cp stress*.del.prj ~/sph-projection/.
