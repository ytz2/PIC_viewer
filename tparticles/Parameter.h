/*
 * Parameter.h
 * This class defines the parameters used in simulation
 *  Created on: Jun 16, 2011
 *      Author: yhliu
 */

#ifndef PARAMETER_H_
#define PARAMETER_H_
#include <iostream>
#include <cmath>
#include <string>
#define pi (3.14159265) //pi
#define forward

using namespace std;

class Parameter {
public:
	Parameter();
	double emass; //mass of e;
	double imass; //mass of i;
	double omass; //mass of o;
	int ne; //number of electron
	int ni; //number of proton
	int no; //number of oxygen
	double dt; //time step
	int nx;  //number of grid in x
	int ny;  //number of grid in y
	int nz;  //number of grid in z
	double dx; // length/grid in x
	double dy; // length/grid in y
	double dz; //length /grid in z
	double xmax;
	double ymax;
	double zmax;
	int stepMax; // the max number of time step
	int stepPrint;//print out each stepPrint steps
	string path; //file path
	string timestep;//time step
	string saveto;
	string initialization;
};

#endif /* PARAMETER_H_ */
