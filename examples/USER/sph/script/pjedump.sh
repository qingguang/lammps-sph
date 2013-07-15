#rm projection.*
#rm spectra.dat

<<<<<<< HEAD
for filename in dump006*.dat; do echo $filename;  
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
awk 'fl{print $1, $2, $7, $8} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
~/lammps-sph/lammps-sph/examples/USER/sph/script/zs_mls_projection 2 512 0.427 1.8 ${filename/.dat/.del} 2 2 2 ;
=======
for filename in dump01*.dat; do echo $filename;  
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
awk 'fl{print $3, $4, $6, $7} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
~/lammps-sph/examples/USER/sph/script/zs_mls_projection 2 512 0.427 1.8 ${filename/.dat/.del} 2 2 2 ;
>>>>>>> 64f38e51be648c771e9d59c9dca93913d801a401
#./zs_mls_projection 2 256 0.214 2.5 ${filename/.dat/.del} 2 2 2 ;
#./zs_mls_projection 2 128 0.107 2.5 ${filename/.dat/.del} 2 2 2 ;
#./zs_mls_projection 2 96 0.08 2.0 ${filename/.dat/.del} 2 2 2 ;
done
#octave --eval Spectra2D.m
<<<<<<< HEAD
#rm dump*.del
#mv dump*.del.prj  ~/sph-projection/.
=======
cp dump0*.del.prj ~/sph-projection/.
>>>>>>> 64f38e51be648c771e9d59c9dca93913d801a401


