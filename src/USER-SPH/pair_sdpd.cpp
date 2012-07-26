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
#include <fenv.h>
#include "math.h"
#include "stdlib.h"
#include "pair_sdpd.h"
#include "atom.h"
#include "force.h"
#include "comm.h"
#include "neighbor.h"
#include "neigh_list.h"
#include "memory.h"
#include "error.h"
#include "domain.h"
#include "update.h"
#include "wiener.h"
#include <iostream>

using namespace LAMMPS_NS;

void PairSDPD::init_style()
{
  if (comm->ghost_velocity == 0)
    error->all(FLERR,"Pair sdpd requires ghost atoms store velocity");

  // if newton off, forces between atoms ij will be double computed
  // using different random numbers

  if (force->newton_pair == 0 && comm->me == 0) error->warning(FLERR,
      "Pair sdpd needs newton pair on for momentum conservation");

  neighbor->request(this);
}


/* ---------------------------------------------------------------------- */

PairSDPD::PairSDPD(LAMMPS *lmp) :
  Pair(lmp) {
  first = 1;
}

/* ---------------------------------------------------------------------- */

PairSDPD::~PairSDPD() {
  if (allocated) {
    memory->destroy(setflag);
    memory->destroy(cutsq);
    memory->destroy(cut);
    memory->destroy(rho0);
    memory->destroy(soundspeed);
    memory->destroy(sdpd_background);
    memory->destroy(B);
    memory->destroy(viscosity);
  }
}

/* ---------------------------------------------------------------------- */

void PairSDPD::compute(int eflag, int vflag) {
  int i, j, ii, jj, inum, jnum, itype, jtype;
  double xtmp, ytmp, ztmp, delx, dely, delz, fpair;

  int *ilist, *jlist, *numneigh, **firstneigh;
  double vxtmp, vytmp, vztmp, imass, jmass, fi, fj, h, ih, ihsq, velx, vely, velz;
  double rsq, tmp, wfd, delVdotDelR, deltaE;

  if (eflag || vflag)
    ev_setup(eflag, vflag);
  else
    evflag = vflag_fdotr = 0;

  double **v = atom->vest;
  double **x = atom->x;
  double **f = atom->f;
  double *rho = atom->rho;
  double *mass = atom->mass;
  double *de = atom->de;
  double *drho = atom->drho;
  int *type = atom->type;
  int nlocal = atom->nlocal;
  int newton_pair = force->newton_pair;
  const int ndim = domain->dimension;
  Wiener wiener(ndim);
  const double sqrtdt = sqrt(update->dt);
  
  double smimj, smjmi;
  /// Boltzmann constant
  const double k_bltz= 1.3806503e-23;
  double eij[ndim];
  double _dUi[ndim];
  double random_force[ndim];
  
  if (first) {
    for (i = 1; i <= atom->ntypes; i++) {
      for (j = 1; i <= atom->ntypes; i++) {
        if (cutsq[i][j] > 1.e-32) {
          if (!setflag[i][i] || !setflag[j][j]) {
            if (comm->me == 0) {
              printf(
		     "SPH particle types %d and %d interact with cutoff=%g, but not all of their single particle properties are set.\n",
		     i, j, sqrt(cutsq[i][j]));
            }
          }
        }
      }
    }
    first = 0;
  }

  inum = list->inum;
  ilist = list->ilist;
  numneigh = list->numneigh;
  firstneigh = list->firstneigh;

  // loop over neighbors of my atoms
  for (ii = 0; ii < inum; ii++) {
    i = ilist[ii];
    xtmp = x[i][0];
    ytmp = x[i][1];
    ztmp = x[i][2];
    vxtmp = v[i][0];
    vytmp = v[i][1];
    vztmp = v[i][2];
    itype = type[i];
    jlist = firstneigh[i];
    jnum = numneigh[i];

    imass = mass[itype];

    // compute pressure of atom i with Tait EOS
    tmp = rho[i] / rho0[itype];
    fi = tmp * tmp * tmp;
    fi = B[itype] * (fi * fi * tmp - sdpd_background[itype] );

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

        wfd = h - sqrt(rsq);
        if (ndim == 3) {
          // Lucy Kernel, 3d
          // Note that wfd, the derivative of the weight function with respect to r,
          // is lacking a factor of r.
          // The missing factor of r is recovered by
          // (1) using delV . delX instead of delV . (delX/r) and
          // (2) using f[i][0] += delx * fpair instead of f[i][0] += (delx/r) * fpair
          wfd = -25.066903536973515383e0 * wfd * wfd * ihsq * ihsq * ihsq * ih;
        } else {
          // Lucy Kernel, 2d
          wfd = -19.098593171027440292e0 * wfd * wfd * ihsq * ihsq * ihsq;
        }

        // compute pressure  of atom j with Tait EOS
        tmp = rho[j] / rho0[jtype];
        fj = tmp * tmp * tmp;
        fj = B[jtype] * (fj * fj * tmp - sdpd_background[jtype] );

        velx=vxtmp - v[j][0];
        vely=vytmp - v[j][1];
        velz=vztmp - v[j][2];

        // dot product of velocity delta and distance vector
        delVdotDelR = delx * velx + dely * vely + delz * velz;
       
	// Morris Viscosity (Morris, 1996)

        if (ndim==2)
	  {
	    eij[0]= delx/sqrt(rsq); 
	    eij[1]= dely/sqrt(rsq);    
	  }
        else
	  {
	    eij[0]= delx/sqrt(rsq);
	    eij[1]= dely/sqrt(rsq);
	    eij[2]= delz/sqrt(rsq);
	  }
 
        const double Fij=-wfd;
        smimj = sqrt(imass/jmass); smjmi = 1.0/smimj;
        wiener.get_wiener_Espanol(sqrtdt);
	const double numi=rho[i]/imass;
	const double numj=rho[j]/jmass;
        const double fvisc = viscosity[itype][jtype] *(1/(numi*numi)+1/(numj*numj)) * wfd;

        //define random force
        for (int di=0;di<ndim;di++) {
           random_force[di]=0;          
         for (int dj=0;dj<ndim;dj++)
            random_force[di]+=wiener.sym_trclss[di][dj]*eij[dj];
        }
        const double Ti= sdpd_temp[itype][jtype];
        for (int di=0;di<ndim;di++) {
          if (Ti>0) {
            const double Zij = -4.0*k_bltz*Ti*fvisc;
            const  double Aij = sqrt(Zij);
            const double Bij = 0.0;
            _dUi[di] = (random_force[di]*Aij + Bij*wiener.trace_d*eij[di])  / update->dt;
          } else {
            _dUi[di] = 0.0;
          }
        }

	const double Vi = imass / rho[i];
	const double Vj = jmass / rho[j];
        fpair = - (fi*Vi*Vi + fj*Vj*Vj) * wfd;
        /// TODO: energy is wrong
        deltaE = -0.5 *(fpair * delVdotDelR + fvisc * (velx*velx + vely*vely + velz*velz));

	//modify force pair

	f[i][0] += delx * fpair + velx * fvisc+_dUi[0];
	f[i][1] += dely * fpair + vely * fvisc+_dUi[1];
	if (domain->dimension ==3 ) {
	  f[i][2] += delz * fpair + velz * fvisc +_dUi[2];
	} 
   
	drho[i] += jmass * delVdotDelR * wfd;

        // change in thermal energy
        de[i] += deltaE;


	if (newton_pair || j < nlocal) {
	  f[j][0] -= delx*fpair + velx*fvisc + _dUi[0];
	  f[j][1] -= dely*fpair + vely*fvisc + _dUi[1];
	  if (domain->dimension ==3 ) {
	    f[j][2] -= delz*fpair + velz*fvisc + _dUi[2];
	  }
	  de[j] += deltaE;
          drho[j] += imass * delVdotDelR * wfd;
        }
        //modify until this line
        if (evflag)
          ev_tally_sdpd(i, j, nlocal, newton_pair, 0.0, 0.0, 
	   		delx * fpair + velx * fvisc+_dUi[0],
	   		dely * fpair + vely * fvisc+_dUi[1],
	   		delz * fpair + velz * fvisc +_dUi[2],
	   		delx, dely, delz);
      }
    }
  }
  if (vflag_fdotr) virial_fdotr_compute();
}

/* ----------------------------------------------------------------------
   allocate all arrays
   ------------------------------------------------------------------------- */
void PairSDPD::allocate() {
  allocated = 1;
  int n = atom->ntypes;

  memory->create(setflag, n + 1, n + 1, "pair:setflag");
  for (int i = 1; i <= n; i++)
    for (int j = i; j <= n; j++)
      setflag[i][j] = 0;

  memory->create(cutsq, n + 1, n + 1, "pair:cutsq");
  memory->create(rho0, n + 1, "pair:rho0");
  memory->create(soundspeed, n + 1, "pair:soundspeed");
  memory->create(sdpd_background, n + 1, "pair:sdpd_background");
  memory->create(B, n + 1, "pair:B");
  memory->create(cut, n + 1, n + 1, "pair:cut");
  memory->create(viscosity, n + 1, n + 1, "pair:viscosity");
  memory->create(sdpd_temp, n + 1, n + 1, "pair:sdpd_temp");
}

/* ----------------------------------------------------------------------
   global settings
   ------------------------------------------------------------------------- */
void PairSDPD::settings(int narg, char **arg) {
  if (narg != 0)
    error->all(FLERR,
               "Illegal number of setting arguments for pair_style sdpd");
}

/* ----------------------------------------------------------------------
   set coeffs for one or more type pairs
   ------------------------------------------------------------------------- */
void PairSDPD::coeff(int narg, char **arg) {
  if ( (narg != 7) && (narg != 8) )
    error->all(FLERR,
               "Incorrect args for pair_style sdpd coefficients: 6 or 7 parameters are required");
  if (!allocated)
    allocate();

  int ilo, ihi, jlo, jhi;
  force->bounds(arg[0], atom->ntypes, ilo, ihi);
  force->bounds(arg[1], atom->ntypes, jlo, jhi);
  double rho0_one = force->numeric(arg[2]);
  double soundspeed_one = force->numeric(arg[3]);
  double viscosity_one = force->numeric(arg[4]);
  double cut_one = force->numeric(arg[5]);
  double sdpd_temp_one = force->numeric(arg[6]);
  double sdpd_background_one;
  if (narg>7) {
    sdpd_background_one = force->numeric(arg[7]);
  } else {
    sdpd_background_one = 1.0;
  }

  /// TODO: I removed rho0_one for B_one
  double B_one = soundspeed_one * soundspeed_one / 7.0;
  int count = 0;
  for (int i = ilo; i <= ihi; i++) {
    rho0[i] = rho0_one;
    soundspeed[i] = soundspeed_one;
    sdpd_background[i] = sdpd_background_one;
    B[i] = B_one;
    for (int j = MAX(jlo,i); j <= jhi; j++) {
      viscosity[i][j] = viscosity_one;
      sdpd_temp[i][j] = sdpd_temp_one;
      //printf("setting cut[%d][%d] = %f\n", i, j, cut_one);
      cut[i][j] = cut_one;
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

double PairSDPD::init_one(int i, int j) {

  if (setflag[i][j] == 0) {
    error->all(FLERR,"Not all pair sdpd coeffs are set");
  }
  cut[j][i] = cut[i][j];
  viscosity[j][i] = viscosity[i][j];
  sdpd_temp[j][i] = sdpd_temp[i][j];
  return cut[i][j];
}

/* ---------------------------------------------------------------------- */

double PairSDPD::single(int i, int j, int itype, int jtype,
                        double rsq, double factor_coul, double factor_lj, double &fforce) {
  std::cerr << "PairSDPD:single is called" << std::endl;
  fforce = 0.0;
  return 0.0;
}

/* ----------------------------------------------------------------------
   tally eng_vdwl and virial into global and per-atom accumulators
   need i < nlocal test since called by bond_quartic and dihedral_charmm
------------------------------------------------------------------------- */

void PairSDPD::ev_tally_sdpd(int i, int j, int nlocal, int newton_pair,
			     double evdwl, double ecoul, 
			     double fcompx, double fcompy, double fcompz,
			     double delx, double dely, double delz)
{
  double evdwlhalf,ecoulhalf,epairhalf,v[6];

  if (eflag_either) {
    if (eflag_global) {
      if (newton_pair) {
	eng_vdwl += evdwl;
	eng_coul += ecoul;
      } else {
	evdwlhalf = 0.5*evdwl;
	ecoulhalf = 0.5*ecoul;
	if (i < nlocal) {
	  eng_vdwl += evdwlhalf;
	  eng_coul += ecoulhalf;
	}
	if (j < nlocal) {
	  eng_vdwl += evdwlhalf;
	  eng_coul += ecoulhalf;
	}
      }
    }
    if (eflag_atom) {
      epairhalf = 0.5 * (evdwl + ecoul);
      if (newton_pair || i < nlocal) eatom[i] += epairhalf;
      if (newton_pair || j < nlocal) eatom[j] += epairhalf;
    }
  }

  if (vflag_either) {
    v[0] = delx*fcompx;
    v[1] = dely*fcompy;
    v[2] = delz*fcompz;
    v[3] = dely*fcompx;
    v[4] = delz*fcompz;
    v[5] = dely*fcompz;

    if (vflag_global) {
      if (newton_pair) {
	virial[0] += v[0];
	virial[1] += v[1];
	virial[2] += v[2];
	virial[3] += v[3];
	virial[4] += v[4];
	virial[5] += v[5];
      } else {
	if (i < nlocal) {
	  virial[0] += 0.5*v[0];
	  virial[1] += 0.5*v[1];
	  virial[2] += 0.5*v[2];
	  virial[3] += 0.5*v[3];
	  virial[4] += 0.5*v[4];
	  virial[5] += 0.5*v[5];
	}
	if (j < nlocal) {
	  virial[0] += 0.5*v[0];
	  virial[1] += 0.5*v[1];
	  virial[2] += 0.5*v[2];
	  virial[3] += 0.5*v[3];
	  virial[4] += 0.5*v[4];
	  virial[5] += 0.5*v[5];
	}
      }
    }

    if (vflag_atom) {
      if (newton_pair || i < nlocal) {
	vatom[i][0] += 0.5*v[0];
	vatom[i][1] += 0.5*v[1];
	vatom[i][2] += 0.5*v[2];
	vatom[i][3] += 0.5*v[3];
	vatom[i][4] += 0.5*v[4];
	vatom[i][5] += 0.5*v[5];
      }
      if (newton_pair || j < nlocal) {
	vatom[j][0] += 0.5*v[0];
	vatom[j][1] += 0.5*v[1];
	vatom[j][2] += 0.5*v[2];
	vatom[j][3] += 0.5*v[3];
	vatom[j][4] += 0.5*v[4];
	vatom[j][5] += 0.5*v[5];
      }
    }
  }
}
