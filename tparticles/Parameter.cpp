/*
 * Parameter.cpp
 *
 *  Created on: Jun 16, 2011
 *      Author: yhliu
 */

#include "Parameter.h"

/*--------------------------------------------------------------
 Constructor, see Homa's info file
 ---------------------------------------------------------------*/
Parameter::Parameter()
{
	emass=1; //mass of e;
	imass=50; //mass of i;
	omass=500; //mass of o;
	ne=1; //number of electron
	ni=1; //number of proton
	no=6; //number of oxygen
	dt=0.1/sqrt(4.*pi); //time step
	nx=7168;  //number of grid in x
	ny=1; //number of grid in y
	nz=7168;  //number of grid in z
	dx=3.119514e-1; // length/grid in x
	dy=3.100868e-01; //length/grid in y
	dz=3.119514e-1; //length /grid in z
	stepMax=1600000; // the max number of time step
	stepPrint=1;//print out each stepPrint steps
	//path="/run/media/yanhua/c6a05398-bff9-3da8-843a-3b8feca9274a/oxygen-run1/data/T.28334/";
	timestep="146240"; //time step to use
	path="/Volumes/Liu/oxygen-run1/data/T."+timestep+"/";
	xmax=2.236068e+03;
	zmax=2.236068e+03;
	ymax=3.100868e-01;
	saveto="/Users/yanhualiu/Dropbox/viewer/tparticles/data/test"+timestep+"_2.dat";//"/home/yanhua/Desktop/test/test.dat";
	initialization="/Users/yanhualiu/Dropbox/viewer/tparticles/initialization.txt";
}
