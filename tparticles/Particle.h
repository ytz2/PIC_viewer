/*
 * Particle.h
 * define the particle behavior
 *  Created on: Dec 6, 2012
 *      Author: yanhualiu
 */

#ifndef PARTICLE_H_
#define PARTICLE_H_
#include <iostream>
#include <fstream>
#include "Parameter.h"

using namespace std;

class Particle {
public:
	Particle(Parameter* para, float mass);
	//set X,V field via 3d input
	void setX(float*);
	void setV(float*);
	//get X,V field info
	float* getX();
	float* getV();
	float getM();
	void print(ostream& out) const;
	//write into file
	void print(ofstream& out)const;
	//calculate the first term
	virtual ~Particle();
private:
	Parameter *para; // parameters needed
	float mass; //mass of this particle
	float xyz[3]; //(x,y,z) location
	float vxyz[3]; // (vx,vy,vz) phase space
};

//operator overloading
ostream& operator<<(ostream& out,const Particle& rhs);
ofstream& operator<<(ofstream& out,const Particle& rhs);
#endif /* PARTICLE_H_ */
