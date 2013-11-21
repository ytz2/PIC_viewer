/*
 * Runner.h
 * Define the running algorithm
 *  Created on: Dec 7, 2012
 *      Author: yanhua
 */

#ifndef RUNNER_H_
#define RUNNER_H_
#include <iostream>
#include "Particle.h"
#include "EMfields.h"
#include "Parameter.h"

class Runner {
public:
	Runner(Parameter* para, EMfields* em);
	void run(Particle* particle,int step);
	virtual ~Runner();
	void printerr(float* test)
	{
		for (int i=0;i<3;i++)
			cerr<<test[i]<<" ";

		cerr<<endl;
	};
private:
	//translate the x,z location to index stored in EM field
	int getIndex(float*) const;
	//update the velocity via BORIS method
	void UpdateVelocity(float* E,float* B, Particle* particle,float dt);
	void CrossProduct(float* result,float* v1, float* v2);
	void PushParticle(Particle *particle,float dt);
	Parameter* para;
	EMfields *em;
};

#endif /* RUNNER_H_ */
