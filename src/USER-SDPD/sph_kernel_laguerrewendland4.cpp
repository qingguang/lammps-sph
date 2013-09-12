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
#include "sph_kernel_laguerrewendland4.h"

double LAMMPS_NS::SPHKernelLaguerreWendland4::w3d(double r) {
  const double norm3d = 9009/(64.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm3d * (
		     pow(1-r,6)*(35*pow(r,2)/3.0+6*r+1)*(27*pow(r,4)/2.0-9*pow(r,2)+1)
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4::w2d(double r) {
  const double norm2d = 1287/(47.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm2d * (
		     pow(1-r,6)*(35*pow(r,2)/3.0+6*r+1)*(27*pow(r,4)/2.0-9*pow(r,2)+1)
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4::dw3d(double r) {
  const double norm3d = 9009/(64.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm3d* (  
		     -6*pow(1-r,5)*(35*pow(r,2)/3+6*r+1)*(27*pow(r,4)/2-9*pow(r,2)+1)
		     +pow(1-r,6)*(70*r/3+6)*(27*pow(r,4)/2-9*pow(r,2)+1)
		     +pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(54*pow(r,3)-18*r)
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4::dw2d(double r) {
  const double norm2d = 1287/(47.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm2d* (  
		     -6*pow(1-r,5)*(35*pow(r,2)/3+6*r+1)*(27*pow(r,4)/2-9*pow(r,2)+1)
		     +pow(1-r,6)*(70*r/3+6)*(27*pow(r,4)/2-9*pow(r,2)+1)
		     +pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(54*pow(r,3)-18*r)
		       );
  } else {
    return 0.0;
  }
}
