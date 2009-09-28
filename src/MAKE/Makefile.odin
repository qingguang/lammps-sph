# odin = 1400 cluster, g++, MPICH, no FFTs

SHELL = /bin/sh
#.IGNORE:

# ---------------------------------------------------------------------
# System-specific settings
# edit as needed for your machine

# additional system libs needed by LAMMPS libs
# NOTE: these settings are ignored if the LAMMPS package (e.g. gpu, meam)
#       which needs these libs is not included in the LAMMPS build

gpu_SYSLIB =          -lcudart
meam_SYSLIB =         -lifcore -lsvml -lompstub -limf
reax_SYSLIB =         -lifcore -lsvml -lompstub -limf
user-atc_SYSLIB =     -lblas -llapack

gpu_SYSLIBPATH =      -L/usr/local/cuda/lib64
meam_SYSLIBPATH =     -L/opt/intel/fce/10.0.023/lib
reax_SYSLIBPATH =     -L/opt/intel/fce/10.0.023/lib
user-atc_SYSLIBPATH = 

include	Makefile.package

# compiler/linker settings
# NOTE: specify how to compile/link with MPI
#       either an MPI installed on your machine, or the src/STUBS dummy lib
# NOTE: specify an FFT option, e.g. -DFFT_NONE, -DFFT_FFTW, etc

CC =		g++
CCFLAGS =	$(PKGINC) -O -I/opt/mpich-mx/include -DFFT_NONE -DLAMMPS_GZIP
DEPFLAGS =	-M
LINK =		g++
LINKFLAGS =	$(PKGPATH) $(PKGPATHSYS)
USRLIB =	$(PKGLIB) -lmpich -lmyriexpress
SYSLIB =$(PKGLIBSYS)
ARCHIVE =	ar
ARFLAGS =	-rc
SIZE =		size

# ---------------------------------------------------------------------
# no need to edit below here

# Link target

$(EXE):	$(OBJ)
	$(LINK) $(LINKFLAGS) $(OBJ) $(USRLIB) $(SYSLIB) -o $(EXE)
	$(SIZE) $(EXE)

# Library target

lib:	$(OBJ)
	$(ARCHIVE) $(ARFLAGS) $(EXE) $(OBJ)

# Compilation rules

%.o:%.cpp
	$(CC) $(CCFLAGS) -c $<

%.d:%.cpp
	$(CC) $(CCFLAGS) $(DEPFLAGS) $< > $@

# Individual dependencies

DEPENDS = $(OBJ:.o=.d)
include $(DEPENDS)
