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
#include "angle_swimmer_harmonic.h"
#include "atom.h"
#include "neighbor.h"
#include "domain.h"
#include "comm.h"
#include "force.h"
#include "math_const.h"
#include "memory.h"
#include "error.h"
#include "update.h"

using namespace LAMMPS_NS;
using namespace MathConst;

#define SMALL 0.001

/* ---------------------------------------------------------------------- */

AngleSwimmerHarmonic::AngleSwimmerHarmonic(LAMMPS *lmp) : Angle(lmp) {}

/* ---------------------------------------------------------------------- */

AngleSwimmerHarmonic::~AngleSwimmerHarmonic()
{
  if (allocated) {
    memory->destroy(setflag);
    memory->destroy(k);
    memory->destroy(T_wave);
    memory->destroy(v_wave);
    memory->destroy(theta_min);
    memory->destroy(theta_max);
  }
}

/* ---------------------------------------------------------------------- */

void AngleSwimmerHarmonic::compute(int eflag, int vflag)
{
  int i1,i2,i3,n,type;
  double delx1,dely1,delz1,delx2,dely2,delz2;
  double eangle,f1[3],f3[3];
  double dtheta,tk;
  double rsq1,rsq2,r1,r2,c,s,a,a11,a12,a22;

  eangle = 0.0;
  if (eflag || vflag) ev_setup(eflag,vflag);
  else evflag = 0;
  int *tag   = atom->tag;
  double **x = atom->x;
  double **f = atom->f;
  int **anglelist = neighbor->anglelist;
  int nanglelist = neighbor->nanglelist;
  int nlocal = atom->nlocal;
  int newton_bond = force->newton_bond;
  double physical_time = update->dt * update->ntimestep;
  double theta;

  for (n = 0; n < nanglelist; n++) {
    i1 = anglelist[n][0];
    i2 = anglelist[n][1];
    i3 = anglelist[n][2];
    type = anglelist[n][3];

    // 1st bond

    delx1 = x[i1][0] - x[i2][0];
    dely1 = x[i1][1] - x[i2][1];
    delz1 = x[i1][2] - x[i2][2];

    rsq1 = delx1*delx1 + dely1*dely1 + delz1*delz1;
    r1 = sqrt(rsq1);

    // 2nd bond

    delx2 = x[i3][0] - x[i2][0];
    dely2 = x[i3][1] - x[i2][1];
    delz2 = x[i3][2] - x[i2][2];

    rsq2 = delx2*delx2 + dely2*dely2 + delz2*delz2;
    r2 = sqrt(rsq2);

    // angle (cos and sin)
    theta = gettheta(delx1, dely1, delz1, delx2, dely2, delz2,     r1, r2);
    c = cos(theta);
    s = sin(theta);
    s = 1.0/s;

    // force & energy
    dtheta = theta - theta_current(physical_time, tag[i2], type);
    tk = k[type] * dtheta;

    if (eflag) eangle = tk*dtheta;

    a = -2.0 * tk * s;
    a11 = a*c / rsq1;
    a12 = -a / (r1*r2);
    a22 = a*c / rsq2;

    f1[0] = a11*delx1 + a12*delx2;
    f1[1] = a11*dely1 + a12*dely2;
    f1[2] = a11*delz1 + a12*delz2;
    f3[0] = a22*delx2 + a12*delx1;
    f3[1] = a22*dely2 + a12*dely1;
    f3[2] = a22*delz2 + a12*delz1;

    // apply force to each of 3 atoms
    if (newton_bond || i1 < nlocal) {
      f[i1][0] += f1[0];
      f[i1][1] += f1[1];
      f[i1][2] += f1[2];
    }

    if (newton_bond || i2 < nlocal) {
      f[i2][0] -= f1[0] + f3[0];
      f[i2][1] -= f1[1] + f3[1];
      f[i2][2] -= f1[2] + f3[2];
    }

    if (newton_bond || i3 < nlocal) {
      f[i3][0] += f3[0];
      f[i3][1] += f3[1];
      f[i3][2] += f3[2];
    }

    if (evflag) ev_tally(i1,i2,i3,nlocal,newton_bond,eangle,f1,f3,
			 delx1,dely1,delz1,delx2,dely2,delz2);
  }
}

/* ---------------------------------------------------------------------- */

void AngleSwimmerHarmonic::allocate()
{
  allocated = 1;
  int n = atom->nangletypes;

  memory->create(k,n+1,"angle:k");
  memory->create(T_wave,n+1,"angle:T_wave");
  memory->create(v_wave,n+1,"angle:v_wave");
  memory->create(theta_min,n+1,"angle:theta_min");
  memory->create(theta_max,n+1,"angle:theta_max");

  memory->create(setflag,n+1,"angle:setflag");
  for (int i = 1; i <= n; i++) setflag[i] = 0;
}

/* ----------------------------------------------------------------------
   set coeffs for one or more types
   ------------------------------------------------------------------------- */

void AngleSwimmerHarmonic::coeff(int narg, char **arg)
{
  // arguments K, T_wave, v_wave, theta_min, theta_max
  if (narg != 6) error->all(FLERR,"Incorrect args for angle coefficients (K, T_wave, v_wave, theta_min, theta_max)");
  if (!allocated) allocate();

  int ilo,ihi;
  force->bounds(arg[0],atom->nangletypes,ilo,ihi);

  double k_one = force->numeric(FLERR,arg[1]);
  double T_wave_one = force->numeric(FLERR,arg[2]);
  double v_wave_one = force->numeric(FLERR,arg[3]);
  double theta_min_one = force->numeric(FLERR,arg[4]);
  double theta_max_one = force->numeric(FLERR,arg[5]);
  if (theta_max_one<theta_min_one) error->all(FLERR, "Incorrect args for angle coefficients theta_max < theta_min");

  int count = 0;
  for (int i = ilo; i <= ihi; i++) {
    k[i] = k_one;
    T_wave[i] = T_wave_one;
    v_wave[i] = v_wave_one;
    theta_min[i] = theta_min_one/180.0 * MY_PI;
    theta_max[i] = theta_max_one/180.0 * MY_PI;
    setflag[i] = 1;
    count++;
  }

  if (count == 0) error->all(FLERR,"Incorrect args for angle coefficients");
}

/* ---------------------------------------------------------------------- */

double AngleSwimmerHarmonic::equilibrium_angle(int i)
{
  /// TODO: this can be wrong in some situation.
  return 0.5*(theta_min[i]+theta_max[i]);
}

/* ----------------------------------------------------------------------
   proc 0 writes out coeffs to restart file
   ------------------------------------------------------------------------- */

void AngleSwimmerHarmonic::write_restart(FILE *fp)
{
  fwrite(&k[1],sizeof(double),atom->nangletypes,fp);
  fwrite(&T_wave[1],sizeof(double),atom->nangletypes,fp);
  fwrite(&v_wave[1],sizeof(double),atom->nangletypes,fp);
  fwrite(&theta_min[1],sizeof(double),atom->nangletypes,fp);
  fwrite(&theta_max[1],sizeof(double),atom->nangletypes,fp);
}

/* ----------------------------------------------------------------------
   proc 0 reads coeffs from restart file, bcasts them
   ------------------------------------------------------------------------- */

void AngleSwimmerHarmonic::read_restart(FILE *fp)
{
  allocate();

  if (comm->me == 0) {
    fread(&k[1],sizeof(double),atom->nangletypes,fp);
    fread(&T_wave[1],sizeof(double),atom->nangletypes,fp);
    fread(&v_wave[1],sizeof(double),atom->nangletypes,fp);
    fread(&theta_min[1],sizeof(double),atom->nangletypes,fp);
    fread(&theta_max[1],sizeof(double),atom->nangletypes,fp);
  }
  MPI_Bcast(&k[1],atom->nangletypes,MPI_DOUBLE,0,world);
  MPI_Bcast(&T_wave[1],atom->nangletypes,MPI_DOUBLE,0,world);
  MPI_Bcast(&v_wave[1],atom->nangletypes,MPI_DOUBLE,0,world);
  MPI_Bcast(&theta_min[1],atom->nangletypes,MPI_DOUBLE,0,world);
  MPI_Bcast(&theta_max[1],atom->nangletypes,MPI_DOUBLE,0,world);

  for (int i = 1; i <= atom->nangletypes; i++) setflag[i] = 1;
}

/* ----------------------------------------------------------------------
   proc 0 writes to data file
   ------------------------------------------------------------------------- */

void AngleSwimmerHarmonic::write_data(FILE *fp)
{
  for (int i = 1; i <= atom->nangletypes; i++)
    fprintf(fp,"%d %g %g %g %g %g\n",i,k[i],T_wave[i],v_wave[i],theta_min[i]/MY_PI*180.0,theta_max[i]/MY_PI*180);
}

/* ---------------------------------------------------------------------- */

double AngleSwimmerHarmonic::single(int type, int i1, int i2, int i3)
{
  double **x = atom->x;
  int *tag = atom->tag;

  double delx1 = x[i1][0] - x[i2][0];
  double dely1 = x[i1][1] - x[i2][1];
  double delz1 = x[i1][2] - x[i2][2];
  domain->minimum_image(delx1,dely1,delz1);
  double r1 = sqrt(delx1*delx1 + dely1*dely1 + delz1*delz1);

  double delx2 = x[i3][0] - x[i2][0];
  double dely2 = x[i3][1] - x[i2][1];
  double delz2 = x[i3][2] - x[i2][2];
  domain->minimum_image(delx2,dely2,delz2);
  double r2 = sqrt(delx2*delx2 + dely2*dely2 + delz2*delz2);

  double theta = gettheta(delx1, dely1, delz1, delx2, dely2, delz2,     r1, r2);
  double dtheta = theta - theta_current(update->dt * update->ntimestep, tag[i2], type);
  double tk = k[type] * dtheta;
  return tk*dtheta;
}

double AngleSwimmerHarmonic::theta_current(double physical_time, int n, int type) {
  double th;
  if (periodic_fmod(double(n) + physical_time*v_wave[type], T_wave[type]) > 0.5*T_wave[type]) {
    th = theta_max[type];
  } else {
    th = theta_min[type];
  }
  return th;
}

double AngleSwimmerHarmonic::gettheta(double delx1, double dely1, double,
				      double delx2, double dely2, double,
				      double r1, double r2) {
  double dortx = - dely1;
  double dorty = delx1;
  double cdort = delx2*dortx + dely2*dorty;
  cdort /= r1*r2;

  if (cdort > 1.0) cdort = 1.0;
  if (cdort < -1.0) cdort = -1.0;
  return acos(cdort) + MY_PI/2;
}

double LAMMPS_NS::periodic_fmod(double x, double T) {
  return remainder(x+T/2, T) + T/2;
}
