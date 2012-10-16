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
#include "stdlib.h"
#include "pair_sph_surfacetension.h"
#include "atom.h"
#include "force.h"
#include "comm.h"
#include "memory.h"
#include "error.h"
#include "neigh_list.h"
#include "domain.h"
#include <iostream>

using namespace LAMMPS_NS;

/* ---------------------------------------------------------------------- */

PairSPHSurfaceTension::PairSPHSurfaceTension(LAMMPS *lmp) : Pair(lmp)
{
  restartinfo = 0;
}

/* ---------------------------------------------------------------------- */

PairSPHSurfaceTension::~PairSPHSurfaceTension() {
  if (allocated) {
    memory->destroy(setflag);
    memory->destroy(cutsq);
    memory->destroy(cut);
    memory->destroy(alpha_surface);
  }
}

/* ---------------------------------------------------------------------- */

void PairSPHSurfaceTension::compute(int eflag, int vflag) {
  int i, j, ii, jj, inum, jnum, itype, jtype;
  double xtmp, ytmp, ztmp, delx, dely, delz;

  int *ilist, *jlist, *numneigh, **firstneigh;
  double imass, jmass, h, ih, ihsq;
  double rsq, wfd;

  if (eflag || vflag)
    ev_setup(eflag, vflag);
  else
    evflag = vflag_fdotr = 0;

  double **x = atom->x;
  double **f = atom->f;
  double *mass = atom->mass;
  double *rho = atom->rho;
  double **colorgradient = atom->colorgradient;
  const int ndim = domain->dimension;
  double eij[ndim];
  int *type = atom->type;
  int nlocal = atom->nlocal;
  int newton_pair = force->newton_pair;

  inum = list->inum;
  ilist = list->ilist;
  numneigh = list->numneigh;
  firstneigh = list->firstneigh;

  // loop over neighbors of my atoms and do surface tension

  for (ii = 0; ii < inum; ii++) {
    i = ilist[ii];
    itype = type[i];

    xtmp = x[i][0];
    ytmp = x[i][1];
    ztmp = x[i][2];

    jlist = firstneigh[i];
    jnum = numneigh[i];

    imass = mass[itype];

    for (jj = 0; jj < jnum; jj++) {
      j = jlist[jj];
      j &= NEIGHMASK;

      delx = xtmp - x[j][0];
      dely = ytmp - x[j][1];
      delz = ztmp - x[j][2];
      rsq = delx * delx + dely * dely + delz * delz;
      jtype = type[j];
      jmass = mass[jtype];

      if (rsq < cutsq[itype][jtype]) {
        h = cut[itype][jtype];
        ih = 1.0 / h;
        ihsq = ih * ih;

        // kernel function
        wfd = h - sqrt(rsq);
        if (domain->dimension == 3) {
          // Lucy Kernel, 3d
          // Note that wfd, the derivative of the weight function with respect to r,
          // is lacking a factor of r.
          // The missing factor of r is recovered by
          // deltaE, which is missing a factor of 1/r
          wfd = -25.066903536973515383e0 * wfd * wfd * ihsq * ihsq * ihsq * ih;
        } else {
          // Lucy Kernel, 2d
          wfd = -19.098593171027440292e0 * wfd * wfd * ihsq * ihsq * ihsq;
        }

        jmass = mass[jtype];
        if (ndim==2) {
	  eij[0]= delx/sqrt(rsq); 
	  eij[1]= dely/sqrt(rsq);    
	} else {
	  eij[0]= delx/sqrt(rsq);
	  eij[1]= dely/sqrt(rsq);
	  eij[2]= delz/sqrt(rsq);
	}

	double SurfaceForcei[ndim];
	double SurfaceForcej[ndim];

	double del_i[ndim];
	double del_j[ndim];

	get_phase_stress(colorgradient[i], del_i);
	get_phase_stress(colorgradient[i], del_j);

	if (ndim==2) {
	  SurfaceForcei[0] = del_i[0]*eij[0] + del_i[1]*eij[1];
	  SurfaceForcei[1] = del_i[1]*eij[0] - del_i[0]*eij[1];

	  SurfaceForcej[0] = del_j[0]*eij[0] + del_j[1]*eij[1];
	  SurfaceForcej[1] = del_j[1]*eij[0] - del_j[0]*eij[1];
	} else {
	  /// TODO: make 3D case
	  SurfaceForcei[0] = del_i[0]*eij[0] + del_i[1]*eij[1];
	  SurfaceForcei[1] = del_i[1]*eij[0] - del_i[0]*eij[1];

	  SurfaceForcej[0] = del_j[0]*eij[0] + del_j[1]*eij[1];
	  SurfaceForcej[1] = del_j[1]*eij[0] - del_j[0]*eij[1];
	}

	const double Vi = imass / rho[i];
	const double Vj = jmass / rho[j];
	const double rij = sqrt(rsq);	    
        const double Fij = -wfd / rij;

	f[i][0] += (SurfaceForcei[0]*Vi*Vi + SurfaceForcej[0]*Vj*Vj)*rij*Fij;
	f[i][1] += (SurfaceForcei[1]*Vi*Vi + SurfaceForcej[1]*Vj*Vj)*rij*Fij;
	if (ndim==3) {
	  f[i][2] += (SurfaceForcei[2]*Vi*Vi + SurfaceForcej[2]*Vj*Vj)*rij*Fij;
	}

	//	std::cerr << "colorgradient: " << xtmp << ' ' << ytmp << ' ' << 
	//	  (SurfaceForcei[0]*Vi*Vi + SurfaceForcej[0]*Vj*Vj)*rij*Fij << ' ' <<
	//	  (SurfaceForcei[1]*Vi*Vi + SurfaceForcej[1]*Vj*Vj)*rij*Fij << '\n';

        if (newton_pair || j < nlocal) {
	  f[j][0] -= (SurfaceForcei[0]*Vi*Vi + SurfaceForcej[0]*Vj*Vj)*rij*Fij;
	  f[j][1] -= (SurfaceForcei[1]*Vi*Vi + SurfaceForcej[1]*Vj*Vj)*rij*Fij;
	  if (ndim==3) {
	    f[j][2] -= (SurfaceForcei[2]*Vi*Vi + SurfaceForcej[2]*Vj*Vj)*rij*Fij;
	  }
        }
      }
    }
  }
}

/* ----------------------------------------------------------------------
 allocate all arrays
 ------------------------------------------------------------------------- */

void PairSPHSurfaceTension::allocate() {
  allocated = 1;
  int n = atom->ntypes;

  memory->create(setflag, n + 1, n + 1, "pair:setflag");
  for (int i = 1; i <= n; i++)
    for (int j = i; j <= n; j++)
      setflag[i][j] = 0;

  memory->create(cutsq, n + 1, n + 1, "pair:cutsq");
  memory->create(cut, n + 1, n + 1, "pair:cut");
  memory->create(alpha_surface, n + 1, n + 1, "pair:alpha_surface");
}

/* ----------------------------------------------------------------------
 global settings
 ------------------------------------------------------------------------- */

void PairSPHSurfaceTension::settings(int narg, char **arg) {
  if (narg != 0)
    error->all(FLERR,
        "Illegal number of setting arguments for pair_style sph/surfacetension");
}

/* ----------------------------------------------------------------------
 set coeffs for one or more type pairs
 ------------------------------------------------------------------------- */

void PairSPHSurfaceTension::coeff(int narg, char **arg) {
  if (narg != 4)
    error->all(FLERR,"Incorrect number of args for pair_style sph/surfacetension coefficients");
  if (!allocated)
    allocate();

  int ilo, ihi, jlo, jhi;
  force->bounds(arg[0], atom->ntypes, ilo, ihi);
  force->bounds(arg[1], atom->ntypes, jlo, jhi);

  double alpha_surface_one = force->numeric(arg[2]);
  double cut_one   = force->numeric(arg[3]);

  int count = 0;
  for (int i = ilo; i <= ihi; i++) {
    for (int j = MAX(jlo,i); j <= jhi; j++) {
      //printf("setting cut[%d][%d] = %f\n", i, j, cut_one);
      cut[i][j] = cut_one;
      alpha_surface[i][j] = alpha_surface_one;
      setflag[i][j] = 1;
      count++;
    }
  }

  if (count == 0)
    error->all(FLERR,"Incorrect args for pair coefficients");
}

/* ----------------------------------------------------------------------
 init for one type pair i,j and corresponding j,i
 ------------------------------------------------------------------------- */

double PairSPHSurfaceTension::init_one(int i, int j) {

  if (setflag[i][j] == 0) {
    error->all(FLERR,"All pair sph/surfacetension coeffs are not set");
  }

  cut[j][i] = cut[i][j];
  alpha_surface[j][i] = alpha_surface[i][j];

  return cut[i][j];
}

/* ---------------------------------------------------------------------- */

double PairSPHSurfaceTension::single(int i, int j, int itype, int jtype,
    double rsq, double factor_coul, double factor_lj, double &fforce) {
  fforce = 0.0;

  return 0.0;
}

/* calculate phase stress base on phase gradient */
void get_phase_stress(double* v, double* del_phi) {
  double epsilon = 1e-19;
  double interm0 = 1.0/ ( sqrt(v[0]*v[0] + v[1]*v[1]) + epsilon );
  double interm1 = 0.5 * (v[0]*v[0] - v[1]*v[1]);
  double interm2 = v[0]*v[1];
  del_phi[0] = interm1*interm0;
  del_phi[1] = interm2*interm0;
}
