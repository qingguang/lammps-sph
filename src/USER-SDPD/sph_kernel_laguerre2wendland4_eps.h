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

#ifndef LMP_SPH_KERNEL_LAGUERRE2WENDLAND4_EPS_H
#define LMP_SPH_KERNEL_LAGUERRE2WENDLAND4_EPS_H

#include "math.h"
#include "sph_kernel.h"

namespace LAMMPS_NS {
  class SPHKernelLaguerre2Wendland4Eps : public SPHKernel {
  public:
    virtual double w3d (double r);
    virtual double w2d (double r);
    virtual double dw3d (double r);
    virtual double dw2d (double r);
    static const double eps = 91.0/18.0;
    // 3D
    //static const double eps = 21.0/5.0;
  };
}
#endif
