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
#include "pair_sdpd.h"
#include "atom.h"
#include "force.h"
#include "comm.h"
#include "neigh_list.h"
#include "memory.h"
#include "error.h"
#include "domain.h"
#include "update.h"
#include "wiener.h"
#include <iostream>

using namespace LAMMPS_NS;

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
    memory->destroy(B);
    memory->destroy(viscosity);
  }
}

/* ---------------------------------------------------------------------- */

void PairSDPD::compute(int eflag, int vflag) {
  int i, j, ii, jj, inum, jnum, itype, jtype;
  double xtmp, ytmp, ztmp, delx, dely, delz, fpair;

  int *ilist, *jlist, *numneigh, **firstneigh;
  double vxtmp, vytmp, vztmp, imass, jmass, fi, fj, fvisc, h, ih, ihsq, velx, vely, velz;
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
  
Wiener wiener(domain->dimension);
  const double sqrtdt = sqrt(update->dt);
  wiener.get_wiener(sqrtdt);
  
  double smimj, smjmi, rrhoi, rrhoj;
    //double Ti, Tj; //temperature
    //Vec2d v_eij; //90 degree rotation of pair direction

  double k_bltz=2.3e-23;
    //add variables--------------
/* Vec2d  eij;
  // eij= new double*[domain->dimension];
    //for(int k = 0; k < dimension; k++) eij[k] = new double[dimension];
 // Vec2d  _dUi;
 // Vec2d random_force;
  //std::cout<<"eij "<< eij <<'\n';  
*/
  double Fij;
  int di;
  int dj;
double eij[domain->dimension];
double _dUi[domain->dimension];
double random_force[domain->dimension];
double etai=5e-2;
double zetai=1e-2;
//std::cerr<<eij<<'\n';
 // std::cout << "wiener: " << wiener.Random_p << '\n';
//std::cout << "wiener-sym: " << wiener.sym_trclss[2][1] << '\n';
 
// const double k_bltz=1.380662e-23//[J/K]
  // check consistency of pair coefficients
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
    fi = B[itype] * (fi * fi * tmp - 1.0) / (rho[i] * rho[i]);

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
        if (domain->dimension == 3) {
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
        fj = B[jtype] * (fj * fj * tmp - 1.0) / (rho[j] * rho[j]);

        velx=vxtmp - v[j][0];
        vely=vytmp - v[j][1];
        velz=vztmp - v[j][2];

        // dot product of velocity delta and distance vector
        delVdotDelR = delx * velx + dely * vely + delz * velz;

        // Morris Viscosity (Morris, 1996)

        fvisc = 2 * viscosity[itype][jtype] / (rho[i] * rho[j]);

        fvisc *= imass * jmass * wfd;
//std:cerr<<"viscosity"<<fvisc<<'\n';
//Update RandomForce
/*------------------------------------

Update Random force                   
pair particle state values            
    double Vi, Vj;                    
    double Ti, Tj; //temperature      
    Vec2d v_eij; //90 degree rotation of pair direction

//    extern double k_bltz;

    //define particle state values
    Vi = imass/rho[i]; Vj = jmass/rho[j];
    Ti =T[i]; Tj = T[j];           
 
    wiener.get_wiener(sqrtdt);
 
    //pair focres or change rate
    Vec2d _dUi; //mometum change rate
    double Vi2 = Vi*Vi, Vj2 = Vj*Vj; 

    _dUi = v_eij*wiener.Random_p*sqrt(16.0*k_bltz*shear_rij*Ti*Tj/(Ti + Tj)*(Vi2 + Vj2)*Fij) +
        eij*wiener.Random_v*sqrt(16.0*k_bltz*bulk_rij*Ti*Tj/(Ti + Tj)*(Vi2 + Vj2)*Fij);       
*/                                                                                            
/*----------------------------------------                                                    
Update random force with Espanol method   */                                                    
//pair particle state values                                                                    
   // Vec2d v_eij; //90 degree rotatio
    //add variables-------------
    if (domain->dimension==2)
{
     eij[0]= delx; 
     eij[1]= dely;    
}
else
{
     eij[0]= delx;
     eij[1]= dely;
     eij[2]=delz; 
  
}
/*
if (domain->dimension==2)
{
     _dUi[0]= 0;
     _dUi[1]= 0;
}
else
{
     _dUi[0]= 0;
     _dUi[1]= 0;
     _dUi[2]=0;

}
*/
 
  Fij=-wfd;
//std::cerr<<"eij"<<eij[0];       
  //pair focres or change rate       
    //define particle state values
    smimj = sqrt(imass/jmass); smjmi = 1.0/smimj;
    rrhoi = 1.0/rho[i]; rrhoj = 1.0/rho[j];
  //  Ti =T[i]; Tj = T[j];                   

    wiener.get_wiener_Espanol(sqrtdt);
//std::cerr"domain->dimension"<<domain->dimension<<'\n';
//std::cerr<<"wiener.sym_trclss"<<wiener.sym_trclss[0][0]<<'\n';
//std::cerr<<""<<wiener.trace_d<<'\n';

//define random force
for (di=0;di<domain->dimension;di++)
{for (dj=0;dj<domain->dimension;dj++)
random_force[di]=wiener.sym_trclss[di][dj]*eij[dj];
}
/*
std::cerr<<" randomforce "<<random_force[0]<<" 2part "<<random_force[1]<<'\n';
std::cerr<<" eij "<<eij[0]<<" 2part "<<eij[1]<<'\n';
std::cerr<<" Fij "<<Fij<<'\n';
std::cerr<<" etai "<<etai<<'\n';
std::cerr<<" Ti "<<Ti<<'\n';
std::cerr<<" zetai "<<zetai<<'\n';
std::cerr<<" rrhoi "<<rrhoi<<'\n';
std::cerr<<" rrhoj "<<rrhoj<<'\n';
std::cerr<<" k_bltz "<<k_bltz<<'\n';
std::cerr<<" Fij "<<Fij<<'\n';
*/
double Ti= sdpd_temp[itype][jtype];

for (di=0;di<domain->dimension;di++)
{
//std::cerr<<" _dUi "<<_dUi[0]<<" 2part "<<_dUi[1]<<'\n';
  
    _dUi[di] = random_force[di]*sqrt(16.0*k_bltz*etai*etai/(etai+etai)*Ti*Ti/(Ti+Ti)*(rrhoi*rrhoi+rrhoj*rrhoj)*Fij) +
        eij[di]*wiener.trace_d*sqrt(16.0*k_bltz*zetai*zetai/(zetai+zetai)*Ti*Ti/(Ti + Ti)*(rrhoi*rrhoi+rrhoj*rrhoj)*Fij);
//std::cerr<<" _dUipart "<<16.0*k_bltz*etai*etai/(etai+etai)*Ti*Ti/(Ti+Ti)*(rrhoi*rrhoi+rrhoj*rrhoj)*Fij<<'\n';
//std::cerr<<" sqrt(4) "<<sqrt(4);
}

//std::cerr<<" _dUi "<<_dUi[0]<<" 2part "<<_dUi[2]<<'\n';
       // total pair force & thermal energy increment
        fpair = -imass * jmass * (fi + fj) * wfd;
        deltaE = -0.5 *(fpair * delVdotDelR + fvisc * (velx*velx + vely*vely + velz*velz));

       // printf("testvar= %f, %f \n", delx, dely);
/*
        f[i][0] += delx * fpair + velx * fvisc;
        f[i][1] += dely * fpair + vely * fvisc;
        f[i][2] += delz * fpair + velz * fvisc;

        // and change in density
        drho[i] += jmass * delVdotDelR * wfd;

        // change in thermal energy
        de[i] += deltaE;

        if (newton_pair || j < nlocal) {
          f[j][0] -= delx * fpair + velx * fvisc;
          f[j][1] -= dely * fpair + vely * fvisc;
          f[j][2] -= delz * fpair + velz * fvisc;
          de[j] += deltaE;
          drho[j] += imass * delVdotDelR * wfd;
        }

  */
//modify force pair
        f[i][0] += delx * fpair + velx * fvisc+_dUi[0];
        f[i][1] += dely * fpair + vely * fvisc+_dUi[1];
        f[i][2] += delz * fpair + velz * fvisc;

        // and change in density
        drho[i] += jmass * delVdotDelR * wfd;

        // change in thermal energy
        de[i] += deltaE;

        if (newton_pair || j < nlocal) {
          f[j][0] -= delx * fpair + velx * fvisc+_dUi[0];
          f[j][1] -= dely * fpair + vely * fvisc+_dUi[1];
          f[j][2] -= delz * fpair + velz * fvisc;
          de[j] += deltaE;
          drho[j] += imass * delVdotDelR * wfd;
        }
//modify until this line
      if (evflag)
          ev_tally(i, j, nlocal, newton_pair, 0.0, 0.0, fpair, delx, dely, delz);
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
  if (narg != 7)
    error->all(FLERR,
        "Incorrect args for pair_style sdpd coefficients: six parameters are required");
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
  double B_one = soundspeed_one * soundspeed_one * rho0_one / 7.0;

  int count = 0;
  for (int i = ilo; i <= ihi; i++) {
    rho0[i] = rho0_one;
    soundspeed[i] = soundspeed_one;
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
    error->all(FLERR,"Not all pair sdpd coeffs are not set");
  }

  cut[j][i] = cut[i][j];
  viscosity[j][i] = viscosity[i][j];
  sdpd_temp[j][i] = sdpd_temp[i][j];

  return cut[i][j];
}

/* ---------------------------------------------------------------------- */

double PairSDPD::single(int i, int j, int itype, int jtype,
    double rsq, double factor_coul, double factor_lj, double &fforce) {
  fforce = 0.0;

  return 0.0;
}
