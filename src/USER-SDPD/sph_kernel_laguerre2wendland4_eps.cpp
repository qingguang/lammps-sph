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
#include "sph_kernel_laguerre2wendland4_eps.h"

double LAMMPS_NS::SPHKernelLaguerre2Wendland4Eps::w3d(double r) {
  const double norm3d = -6435.0/(64.0*MathConst::MY_PI*eps-416.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm3d * (
		     pow(1-r,6)*(35.0*pow(r,2)/3.0+6*r+1)*(1-eps*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland4Eps::w2d(double r) {
  const double norm2d = -594.0/(7.0*MathConst::MY_PI*eps-66.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm2d * (
		     pow(1-r,6)*(35.0*pow(r,2)/3+6.0*r+1)*(1-eps*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland4Eps::dw3d(double r) {
  const double norm3d = -6435.0/(64.0*MathConst::MY_PI*eps-416.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm3d* (  
		     -6.0*pow(1-r,5)*(35.0*pow(r,2)/3+6.0*r+1)*(1-eps*pow(r,2))
		     +pow(1-r,6)*(70.0*r/3.0+6.0)*(1-eps*pow(r,2))
		     -2.0*eps*pow(1-r,6)*r*(35.0*pow(r,2)/3.0+6.0*r+1.0)
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland4Eps::dw2d(double r) {
  const double norm2d = -594.0/(7.0*MathConst::MY_PI*eps-66.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm2d* (  
		     -6.0*pow(1-r,5)*(35.0*pow(r,2)/3+6.0*r+1)*(1-eps*pow(r,2))
		     +pow(1-r,6)*(70.0*r/3.0+6.0)*(1-eps*pow(r,2))
		     -2.0*eps*pow(1-r,6)*r*(35.0*pow(r,2)/3.0+6.0*r+1.0)
		       );
  } else {
    return 0.0;
  }
}
