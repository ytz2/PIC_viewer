/*
 * TparticleMgr.h
 *
 *  Created on: Dec 8, 2012
 *      Author: yanhua
 */

#ifndef TPARTICLEMGR_H_
#define TPARTICLEMGR_H_


#include <iostream>
#include <fstream>
#include "EMfields.h"
#include "Particle.h"
#include "Runner.h"
#include "Parameter.h"
#include <vector>
#include <iterator>
#include <algorithm>


using namespace std;

class TparticleMgr {
	typedef vector<Particle*>::iterator it;
public:
	TparticleMgr(); //constructors
	virtual ~TparticleMgr(); //destructors
	void run(); //run the simulation
	void print (int step, ofstream& out); //print to files
	void initialize(); // set up initial conditionss
private:
	vector<Particle*> group;
	EMfields *em;
	Parameter *para;
	Runner *runner;
	void monitor(int step);
};

#endif /* TPARTICLEMGR_H_ */
