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

#ifdef FIX_CLASS

FixStyle(nve/tri,FixNVETri)

#else

#ifndef LMP_FIX_NVE_TRI_H
#define LMP_FIX_NVE_TRI_H

#include "fix_nve.h"

namespace LAMMPS_NS {

class FixNVETri : public FixNVE {
 public:
  FixNVETri(class LAMMPS *, int, char **);
  ~FixNVETri() {}
  int setmask();
  void init();
  void initial_integrate(int);
  void final_integrate();

 private:
  double dtq;
  class AtomVecTri *avec;
};

}

#endif
#endif

/* ERROR/WARNING messages:

E: Illegal ... command

Self-explanatory.  Check the input script syntax and compare to the
documentation for the command.  You can use -echo screen as a
command-line option when running LAMMPS to see the offending line.

E: Fix nve/tri requires atom style tri

UNDOCUMENTED

E: Fix nve/line can only be used for 3d simulations

UNDOCUMENTED

E: Fix nve/tri requires tri particles

UNDOCUMENTED

*/
