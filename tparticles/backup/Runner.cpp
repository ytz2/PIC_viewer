/*
 * Runner.cpp
 *
 *  Created on: Dec 7, 2012
 *      Author: yanhua
 */

#include "Runner.h"

/***************************************************
 * constructor
 ***************************************************/
Runner::Runner(Parameter* para,EMfields *em) {
	this->para=para;
	this->em=em;
}

Runner::~Runner() {
}

/***************************************************
 * Algorithm to push a particle
 ***************************************************/

void Runner::run(Particle* particle,int step)
{
	float efield[3];
	float bfield[3];
	float *pos=particle->getX();
	if (pos[0]<=0 || pos[0]>=para->xmax ||
			abs(pos[2])>=para->zmax/2.)
		return;
	int ind=this->getIndex(particle->getX());
	this->em->querry(ind,efield,bfield);
	if (step != 0)
	  {
	    this->UpdateVelocity(efield,bfield,particle,para->dt);
	    this->PushParticle(particle,para->dt);
	  }
	else
	  this->UpdateVelocity(efield,bfield,particle,-0.5*para->dt);
}

/***************************************************
 * return index of E&B array from (x,y)
 ***************************************************/
int Runner::getIndex(float *xyz) const
{
	int ix=static_cast<int>(xyz[0]/para->xmax *float(para->nx));
	int iz=static_cast<int>((1.0+2.*xyz[2]/para->zmax)*float(para->nz)/2.);
	return 	iz*para->nz+ix;
}

/***************************************************
 * v1xv2
 ***************************************************/
void Runner::CrossProduct(float* result, float* v1,float* v2)
{
	result[0] = v1[1]*v2[2]-v1[2]*v2[1];
	result[1] = -v1[0]*v2[2]+v1[2]*v2[0];
	result[2] = v1[0]*v2[1]-v1[1]*v2[0];
}

/***************************************************
 * Boris method to push particle
 ***************************************************/
void Runner::UpdateVelocity(float* E,float* B, Particle* particle,float dt)
{
//http://www.particleincell.com/wp-content/uploads/2011/07/ParticleIntegrator.java
	float v_minus[3];
	float v_prime[3];
	float v_plus[3];
	float t[3];
	float s[3];
	float t_mag2;
	float v_minus_cross_t[3];
	float v_prime_cross_s[3];
	float new_v[3];
	int dim;
	float *vxyz=particle->getV();
	float mass=particle->getM();
	/*t vector*/
	for (dim=0;dim<3;dim++)
	    t[dim] = B[dim]*0.5*dt/mass;

	/*magnitude of t, squared*/
	t_mag2 = t[0]*t[0] + t[1]*t[1] + t[2]*t[2];

	/*s vector*/
	for (dim=0;dim<3;dim++)
	    s[dim] = 2*t[dim]/(1+t_mag2);

	/*v minus*/
	for (dim=0;dim<3;dim++)
	    v_minus[dim] = vxyz[dim] + E[dim]*0.5*dt/mass;

	/*v prime*/
	CrossProduct(v_minus_cross_t,v_minus, t);
	for (dim=0;dim<3;dim++)
	    v_prime[dim] = v_minus[dim] + v_minus_cross_t[dim];

	/*v prime*/
	CrossProduct(v_prime_cross_s,v_prime, s);
	for (dim=0;dim<3;dim++)
	    v_plus[dim] = v_minus[dim] + v_prime_cross_s[dim];

	/*v n+1/2*/
	for (dim=0;dim<3;dim++)
	    new_v[dim] = v_plus[dim] + E[dim]*0.5*dt/mass;
	//cerr<< new_v[0]<<" "<<new_v[1]<<" "<<new_v[2]<<endl;

	particle->setV(new_v);
}

/***************************************************
 * Push me
 ***************************************************/
void Runner::PushParticle(Particle *particle,float dt)
{
	float *old_x=particle->getX();
	float *v=particle->getV();
	float new_x[3];
	for (int i=0;i<3;i++)
		new_x[i]=old_x[i]+v[i]*dt;
	particle->setX(new_x);
}


