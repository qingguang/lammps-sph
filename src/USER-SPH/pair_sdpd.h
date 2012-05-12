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

#ifdef PAIR_CLASS

PairStyle(sdpd,PairSDPD)

#else

#ifndef LMP_PAIR_SDPD_H
#define LMP_PAIR_SDPD_H

#include "pair.h"

namespace LAMMPS_NS {

class PairSDPD : public Pair {
 public:
  PairSDPD(class LAMMPS *);
  virtual ~PairSDPD();
  virtual void compute(int, int);
  void settings(int, char **);
  void coeff(int, char **);
  void init_style();
  virtual double init_one(int, int);
  virtual double single(int, int, int, int, double, double, double, double &);

 protected:
  double *rho0, *soundspeed, *B;
  double **cut,**viscosity;
  // SDPD temperature
  double **sdpd_temp;
  double *sdpd_background;
  int first;

  void allocate();
  
  // local version of tally function
  void ev_tally_sdpd(int i, int j, int nlocal, int newton_pair,
		     double evdwl, double ecoul, 
		     double fcompx, double fcompy, double fcompz,
		     double delx, double dely, double delz);
  };

}

#endif
#endif
