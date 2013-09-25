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
#include "sph_kernel_laguerrewendland4_eps.h"

double LAMMPS_NS::SPHKernelLaguerreWendland4Eps::w3d(double r) {
  const double norm3d = 405405.0*pow(160*MathConst::MY_PI*pow(eps,4)-4032.0*MathConst::MY_PI*pow(eps,2)+26208.0*MathConst::MY_PI,-1);
  if (r<1.0) {
    return norm3d * (
		     pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4Eps::w2d(double r) {
  const double norm2d = 7722.0*pow(MathConst::MY_PI,-1)*pow(3.0*pow(eps,4.0)-91.0*pow(eps,2.0)+858.0,-1);
  if (r<1.0) {
    return norm2d * (
		     pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4Eps::dw3d(double r) {
  const double norm3d = 405405.0*pow(160*MathConst::MY_PI*pow(eps,4)-4032.0*MathConst::MY_PI*pow(eps,2)+26208.0*MathConst::MY_PI,-1);
  if (r<1.0) {
    return  norm3d* (  
		     -6*pow(1-r,5)*(35*pow(r,2)/3+6*r+1)
		     *(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     +pow(1-r,6)*(70*r/3+6)*(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     +pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(2*pow(eps,4)*pow(r,3)/3-2*pow(eps,2)*r)
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreWendland4Eps::dw2d(double r) {
  const double norm2d = 7722.0*pow(MathConst::MY_PI,-1)*pow(3.0*pow(eps,4.0)-91*pow(eps,2.0)+858.0,-1);
  if (r<1.0) {
    return  norm2d* (  
		     -6*pow(1-r,5)*(35*pow(r,2)/3+6*r+1)
		     *(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     +pow(1-r,6)*(70*r/3+6)*(pow(eps,4)*pow(r,4)/6-pow(eps,2)*pow(r,2)+1)
		     +pow(1-r,6)*(35*pow(r,2)/3+6*r+1)*(2*pow(eps,4)*pow(r,3)/3-2*pow(eps,2)*r)
		       );
  } else {
    return 0.0;
  }
}
