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

#ifdef COMPUTE_CLASS

ComputeStyle(meso_diff/atom,ComputeMesoDiffAtom)

#else

#ifndef LMP_COMPUTE_MESO_DIFF_ATOM_H
#define LMP_COMPUTE_MESO_DIFF_ATOM_H

#include "compute.h"

namespace LAMMPS_NS {

class ComputeMesoDiffAtom : public Compute {
 public:
  ComputeMesoDiffAtom(class LAMMPS *, int, char **);
  ~ComputeMesoDiffAtom();
  void init();
  void init_list(int, class NeighList *);
  void compute_peratom();
  double memory_usage();

 private:
  int nmax;
  double cutoff;
  double cutsq;
  class NeighList *list;
  int    ivariable;
  double *diffVector;
  double *varVector;
};

}

#endif
#endif
