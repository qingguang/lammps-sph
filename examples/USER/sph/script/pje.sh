
#Format: zs_sph_projection num_dim num_particles L Overlap input_filename file_type kernel_type projection_order
#File Type 1: x y z vx vy vz ax ay az rho
#File Type 2: x y z vx vy vz
./zs_mls_projection 3 20 5e-4 2.7 dump0003*.dat 2 2 2
