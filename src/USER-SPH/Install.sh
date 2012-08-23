# Install/unInstall package files in LAMMPS

if (test $1 = 1) then

  cp -p pair_sdpd.cpp ..
  cp -p pair_sdpd_rhosum.cpp ..
  cp -p pair_sph_colorgradient.cpp ..
  cp -p wiener.cpp .. 
  cp -p atom_vec_meso.cpp ..
  cp -p pair_sph_heatconduction.cpp ..
  cp -p pair_sph_idealgas.cpp ..
  cp -p pair_sph_lj.cpp ..
  cp -p pair_sph_rhosum.cpp ..
  cp -p pair_sph_taitwater.cpp ..
  cp -p pair_sph_taitwater_morris.cpp ..
  cp -p compute_meso_e_atom.cpp ..
  cp -p compute_meso_rho_atom.cpp ..
  cp -p compute_meso_colorgradient_atom.cpp ..
  cp -p compute_meso_t_atom.cpp ..
  cp -p fix_meso.cpp ..
  cp -p fix_meso_stationary.cpp ..

  cp -p pair_sdpd.h ..
  cp -p pair_sdpd_rhosum.h ..
  cp -p pair_sph_colorgradient.h ..
  cp -p wiener.h .. 
  cp -p atom_vec_meso.h ..
  cp -p pair_sph_heatconduction.h ..
  cp -p pair_sph_idealgas.h ..
  cp -p pair_sph_lj.h ..
  cp -p pair_sph_rhosum.h ..
  cp -p pair_sph_taitwater.h ..
  cp -p pair_sph_taitwater_morris.h ..
  cp -p compute_meso_e_atom.h ..
  cp -p compute_meso_rho_atom.h ..
  cp -p compute_meso_colorgradient_atom.h ..
  cp -p compute_meso_t_atom.h ..
  cp -p fix_meso.h ..
  cp -p fix_meso_stationary.h ..

elif (test $1 = 0) then
  rm -f ../pair_sdpd.cpp
  rm -f ../pair_sdpd_rhosum.cpp
  rm -f ../pair_sph_colorgradient.cpp
  rm -f ../wiener.cpp 
  rm -f ../atom_vec_meso.cpp
  rm -f ../pair_sph_heatconduction.cpp
  rm -f ../pair_sph_idealgas.cpp
  rm -f ../pair_sph_lj.cpp
  rm -f ../pair_sph_rhosum.cpp
  rm -f ../pair_sph_taitwater.cpp
  rm -f ../pair_sph_taitwater_morris.cpp
  rm -f ../compute_meso_e_atom.cpp
  rm -f ../compute_meso_rho_atom.cpp
  rm -f ../compute_meso_colorgradient_atom.cpp
  rm -f ../compute_meso_t_atom.cpp
  rm -f ../fix_meso.cpp
  rm -f ../fix_meso_stationary.cpp

  rm -f ../pair_sdpd.h
  rm -f ../pair_sdpd_rhosum.h
  rm -f ../pair_sph_colorgradient.h
  rm -f ../wiener.h
  rm -f ../atom_vec_meso.h
  rm -f ../pair_sph_heatconduction.h
  rm -f ../pair_sph_idealgas.h
  rm -f ../pair_sph_lj.h
  rm -f ../pair_sph_rhosum.h
  rm -f ../pair_sph_taitwater.h
  rm -f ../pair_sph_taitwater_morris.h
  rm -f ../compute_meso_e_atom.h
  rm -f ../compute_meso_rho_atom.h
  rm -f ../compute_meso_colorgradient_atom.h
  rm -f ../compute_meso_t_atom.h
  rm -f ../fix_meso.h
  rm -f ../fix_meso_stationary.h

fi
