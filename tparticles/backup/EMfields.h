/*
 * EMfields.h
 *
 *  Created on: Dec 7, 2012
 *      Author: yanhualiu
 */

#ifndef EMFIELDS_H_
#define EMFIELDS_H_
#include <iostream>
#include <fstream>
#include "Parameter.h"
#include <string>
using namespace std;

class EMfields {
public:
	EMfields(Parameter *para);
	void querry(int loc, float *efield, float *bfield) const;
	virtual ~EMfields();
private:
	void read_gda(float *data,const char* var);
	float *ex;
	float *ey;
	float *ez;
	float *bx;
	float *by;
	float *bz;
	Parameter *para;
};

#endif /* EMFIELDS_H_ */
