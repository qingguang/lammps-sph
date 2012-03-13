
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
#File Type 1: x y z vx vy vz ax ay az rho
#File Type 2: x y z vx vy vz
rm projection.*
awk 'fl{print $3, $4, $5, $6,$7,$8} /ITEM: ATOMS/{fl=1}' dump0*.dat > projection.dat
./zs_mls_projection 3 10 2.5e-4 1.6 projection.dat 2 2 2
