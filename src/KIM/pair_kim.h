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

PairStyle(kim,PairKIM)

#else

#ifndef LMP_PAIR_KIM_H
#define LMP_PAIR_KIM_H

class KIM_API_model;
#include "pair.h"

namespace LAMMPS_NS {

class PairKIM : public Pair {
 public:
  PairKIM(class LAMMPS *);
  ~PairKIM();

  void compute(int, int);
  void settings(int, char **);
  void coeff(int, char **);
  void init_style();
  double init_one(int, int);
  int pack_reverse_comm(int, int, double *);
  void unpack_reverse_comm(int, int *, double *);
  double memory_usage();

 private:
  double cut_global;            // returned from KIM model

  char **elements;              // names of unique elements
  int *map;                     // mapping from atom types to elements
  int nelements;                // # of unique elements

  int maxall;
  int *kimtype;                 // KIM atom types for each LAMMPS atom
  double **fcopy;               // copy of f, when running with pair hybrid
  int hybrid;                   // 1 if running with pair hybrid

  int *onebuf;                  // neighbors of one atom
  int molecular;

  void allocate();

  // KIM data

  // static PairKIM *self;
  KIM_API_model *pkim;
  int coordinates_ind,numberOfParticles_ind,numberParticleTypes_ind;
  int particleTypes_ind,compute_ind;
  int get_neigh_ind,neighObject_ind;
  int cutoff_ind,energy_ind;
  int particleEnergy_ind,force_ind,forces_ind,virialGlobal_ind;
  int particleVirial_ind,process_dEdr_ind;
  int localnall;
  int pointsto;    //get_neigh iterator index
  double *Rij;//size of [3*KIM_API_MAX_NEIGHBORS]
  struct process_fij_4_pair_KIM{
    double *virialGlobal;
    double *particleVirial;
    int virialGlobal_flag;
    int particleVirial_flag;
    int *numberOfParticles;
    bool halfNeighbors;
  };
  process_fij_4_pair_KIM process_dE;
  
  bool support_atypes;
  bool support_Rij;

  char *testname;
  char *modelname;
  char testfile[160];
  char modelfile[160];
  char *test_descriptor_string;

  int *atypeMapKIM;              // one pair of values per KIM element used
                                 // 1st value = element index
                                 // 2nd value = KIM atom type

  void kim_error(int, const char *, int);
  void kim_init();
  void kim_free();
  void set_statics();
  void set_volatiles();
  void init2zero(KIM_API_model *, int *);

  // static methods used as callbacks from KIM

  static int get_neigh(void **,int *, int *, int *, int *, int **, double **);
  static void process_dEdr(KIM_API_model **, double *, double *,
			    double **, int *, int *, int *);
};

}

#endif
#endif
