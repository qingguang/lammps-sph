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
#include "sph_kernel_laguerregaussian.h"

double LAMMPS_NS::SPHKernelLaguerreGaussian::w3d(double r) {
  r = r*n;
  const double norm3d = 216*pow(MathConst::MY_PI,-3.0/2.0)    *     n*n*n;
  if (r<n) {
    return norm3d * (
		     (27*pow(r,4)/2-9*pow(r,2)+1)*exp(-9*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreGaussian::w2d(double r) {
  r = r*n;
  const double norm2d = 27.0/MathConst::MY_PI                  *    n*n;
  if (r<n) {
    return norm2d * (
		     (27*pow(r,4)/2-9*pow(r,2)+1)*exp(-9*pow(r,2))
		     );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreGaussian::dw3d(double r) {
  r = r*n;
  const double norm3d = 216*pow(MathConst::MY_PI,-3/2)          *    n*n*n*n;
  if (r<n) {
    return  norm3d* (  
		     (54*pow(r,3)-18*r)*exp(-9*pow(r,2))-18*r*(27*pow(r,4)/2-9*pow(r,2)+1)
                                       *exp(-9*pow(r,2))
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelLaguerreGaussian::dw2d(double r) {
  r = r*n;
  const double norm2d = 27.0/MathConst::MY_PI                   *    n*n*n;
  if (r<n) {
    return  norm2d* (  
		     (54*pow(r,3)-18*r)*exp(-9*pow(r,2))-18*r*(27*pow(r,4)/2-9*pow(r,2)+1)
		     *exp(-9*pow(r,2))
		       );

  } else {
    return 0.0;
  }
}
