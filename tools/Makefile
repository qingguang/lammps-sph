# Makefile for serial tools

#
# Targets
#

all:
	$(MAKE) binary2txt restart2data chain micelle2d data2xmovie

binary2txt:	binary2txt.o
	g++ -g binary2txt.o -o binary2txt

restart2data:	restart2data.o
	g++ -g -O0 restart2data.o -o restart2data

chain:	chain.o
	gfortran chain.o -o chaing	
	#gfortran chain.o -o chain
micelle2d:	micelle2d.o	
	gfortran micelle2d.o -o micelle2d

data2xmovie:	data2xmovie.o
	g++ -g data2xmovie.o -o data2xmovie

thermo_extract:	thermo_extract.o
	gcc -g thermo_extract.o -o thermo_extract

clean:
	rm binary2txt restart2data chain micelle2d data2xmovie
	rm thermo_extract
	rm *.o

#
# Rules
#

.cpp.o:
	g++ -g -c $<

.c.o:
	gcc -g -c $<

.f.o:	
	gfortran -O -w -c $<
