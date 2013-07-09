/* ----------------------------------------------------------------------
 LAMMPS - Large-scale Atomic/Molecular Massively Parallel Simulator
 http://lammps.sandia.gov, Sandia National Laboratories
 Steve Plimpton, sjplimp@sandia.gov

 Copyright (2003) Sandia Corporation.  Under the terms of Contract
 DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
 certain rights in this software.  This software is distributed under
 the GNU General Public License.

 See the README file in the top-level LAMMPS directory.
 ------------------------------------------------------------------------- */

#include "math.h"
#include "sph_kernel_lucy.h"

double LAMMPS_NS::SPHKernelLucy::w3d(double r) {
  double norm3d = 2.088908628081126;
  if (r<1.0) {
    return norm3d*(1+3*r)*(1-r)*(1-r)*(1-r);
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLucy::w2d(double r) {
  double norm2d = 1.591549430918954;
  if (r<1.0) {
    return norm2d*(1+3*r)*(1-r)*(1-r)*(1-r);
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLucy::dw3d(double r) {
  double norm3d = 2.088908628081126;
  if (r<1) {
    return  norm3d* (3*(1-r)*(1-r)*(1-r)-3*(1-r)*(1-r)*(3*r+1));
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLucy::dw2d(double r) {
  double norm2d = 1.591549430918954;
  if (r<1) {
    return  norm2d* (3*(1-r)*(1-r)*(1-r)-3*(1-r)*(1-r)*(3*r+1));
  } else {
    return 0.0;
  }
}

