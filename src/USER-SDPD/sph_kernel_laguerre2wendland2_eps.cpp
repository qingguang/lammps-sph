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
#include "sph_kernel_laguerre2wendland2_eps.h"

double LAMMPS_NS::SPHKernelLaguerre2Wendland2Eps::w3d(double r) {
  const double norm3d = -630.0/(10.0*MathConst::MY_PI*eps-51.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm3d * (
		     pow(1-r,4)*(3.0*r+1)*(1.0-eps*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland2Eps::w2d(double r) {
  const double norm2d = -420.0/(7.0*MathConst::MY_PI*eps-52.0*MathConst::MY_PI);
  if (r<1.0) {
    return norm2d * (
		     pow(1-r,4)*(3.0*r+1)*(1.0-eps*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland2Eps::dw3d(double r) {
  const double norm3d = -630.0/(10.0*MathConst::MY_PI*eps-51.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm3d* (
		     -4.0*pow(1-r,3)*(3.0*r+1)*(1.0-eps*pow(r,2))
		     +3.0*pow(1-r,4)*(1.0-eps*pow(r,2))-2.0*eps*pow(1-r,4)*r*(3*r+1)
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerre2Wendland2Eps::dw2d(double r) {
  const double norm2d = -420.0/(7.0*MathConst::MY_PI*eps-52.0*MathConst::MY_PI);
  if (r<1.0) {
    return  norm2d* (
		     -4.0*pow(1-r,3)*(3.0*r+1)*(1-eps*pow(r,2))
		     +3.0*pow(1-r,4)*(1-eps*pow(r,2))-2.0*eps*pow(1-r,4)*r*(3*r+1)
		     );
  } else {
    return 0.0;
  }
}
