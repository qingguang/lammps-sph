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
#include "math_const.h"
#include "sph_kernel_wendland4.h"

double LAMMPS_NS::SPHKernelWendland4::w3d(double r) {
  const double norm3d = 495.0/(32.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm3d*( pow(1.0-r,6)*(35.0*pow(r,2)/3.0+6.0*r+1.0) );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland4::w2d(double r) {
  const double norm2d = 9.0/MathConst::MY_PI;
  if (r<1.0) {
    return norm2d*( pow(1.0-r,6)*(35.0*pow(r,2)/3.0+6.0*r+1.0) );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland4::dw3d(double r) {
  const double norm3d = 495.0/(32.0*MathConst::MY_PI);
  if (r<1) {
    return  norm3d*( pow(1-r,6)*(70.0*r/3.0+6.0)-6.0*pow(1-r,5)*(35.0*pow(r,2)/3+6.0*r+1.0) );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland4::dw2d(double r) {
  const double norm2d = 9.0/MathConst::MY_PI;
  if (r<1) {
    return  norm2d*( pow(1-r,6)*(70.0*r/3.0+6.0)-6.0*pow(1-r,5)*(35.0*pow(r,2)/3+6*r+1.0) );
  } else {
    return 0.0;
  }
}

