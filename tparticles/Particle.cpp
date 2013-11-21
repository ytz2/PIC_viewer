/*
 * Particle.cpp
 *
 *  Created on: Dec 6, 2012
 *      Author: yanhualiu
 */

#include "Particle.h"

/***************************************************
 * constructor
 ***************************************************/
Particle::Particle(Parameter* para, float mass)
{
	this->para=para;
	this->mass=mass;
	if (mass==1.)
		mass=-1.;
	for (int i=0;i<=2;i++)
	{
		vxyz[i]=0.;
		xyz[i]=0.;
	}
	xyz[0]=1000.;
	vxyz[0]=0.;
}

/***************************************************
 * destructor
 ***************************************************/
Particle::~Particle() {

}

/*--------------------------------------------------------------
 Set the (x,y) location, and (vx,vy)
 ---------------------------------------------------------------*/
void Particle::setX(float *pos)
{
	for (int i=0;i<3;i++)
		xyz[i]=pos[i];
}
void Particle::setV(float *V)
{
  for (int i=0;i<3;i++)
    vxyz[i]=V[i];
}
/*--------------------------------------------------------------
 Get x,v
 ---------------------------------------------------------------*/
float* Particle::getX()
{
	return	xyz;
}
float* Particle::getV()
{
	return	vxyz;
}
float Particle::getM()
{
	return this->mass;
}
/*--------------------------------------------------------------
print to the screen
 ---------------------------------------------------------------*/
void Particle::print(ostream& out) const
{
	out<<"X, V: "<<endl;
	out<<"x:"<<xyz[0]<<","
			<<vxyz[0]<<","<<endl;
	out<<"y:"<<xyz[1]<<","
			<<vxyz[1]<<","<<endl;
	out<<"z:"<<xyz[2]<<","
			<<vxyz[2]<<","<<endl;
}
/*--------------------------------------------------------------
print to the file
 ---------------------------------------------------------------*/
void Particle::print(ofstream& out) const
{
	for (int i=0;i<=2;i++)
		out<<xyz[i]<<" ";
	for (int i=0;i<=2;i++)
		out<<vxyz[i]<<" ";
}

/*--------------------------------------------------------------
operator overloading
 ---------------------------------------------------------------*/
ostream& operator<<(ostream& out,const Particle& rhs)
{
	rhs.print(out);
	return out;
}
ofstream& operator<<(ofstream& out,const Particle& rhs)
{
	rhs.print(out);
	return out;
}
