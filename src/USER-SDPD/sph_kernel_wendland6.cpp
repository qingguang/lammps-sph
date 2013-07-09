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
#include "sph_kernel_wendland6.h"

double LAMMPS_NS::SPHKernelWendland6::w3d(double r) {
  const double PI  = 3.141592653589793238462;
  const double norm3d = 1365.0/(64.0*PI);
  if (r<1.0) {
    return norm3d * ( pow(1-r,8)*(32*pow(r,3)+25*pow(r,2)+8*r+1) );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland6::w2d(double r) {
  const double PI = 3.141592653589793238462;
  const double norm2d = 78.0/(7.0*PI);
  if (r<1.0) {
    return norm2d * ( pow(1-r,8)*(32*pow(r,3)+25*pow(r,2)+8*r+1) );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland6::dw3d(double r) {
  const double PI  = 3.141592653589793238462;
  const double norm3d = 1365.0/(64.0*PI);
  if (r<1) {
    return  norm3d* (  
		     352*pow(r,10)-2310*pow(r,9)+6336*pow(r,8)-9240*pow(r,7)+7392*pow(r,6)
		     -2772*pow(r,5)+264*pow(r,3)-22*r 
		       );
  } else {
    return 0.0;
  }
}

double LAMMPS_NS::SPHKernelWendland6::dw2d(double r) {
  const double PI = 3.141592653589793238462;
  const double norm2d = 78.0/(7.0*PI);
  if (r<1) {
    return  norm2d* (  
		     352*pow(r,10)-2310*pow(r,9)+6336*pow(r,8)-9240*pow(r,7)+7392*pow(r,6)
		     -2772*pow(r,5)+264*pow(r,3)-22*r 
		       );
  } else {
    return 0.0;
  }
}

