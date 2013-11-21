/*
 * EMfields.cpp
 *
 *  Created on: Dec 7, 2012
 *      Author: yanhualiu
 */

#include "EMfields.h"

using namespace std;

/*--------------------------------------------------------------
Constructor
 ---------------------------------------------------------------*/
EMfields::EMfields(Parameter *para) {
	this->para=para;
	long length=para->nx*para->nz;
	ex=new float[length];
	ey=new float[length];
	ez=new float[length];
	bx=new float[length];
	by=new float[length];
	bz=new float[length];
	this->read_gda(bx,(para->path+"bx_"+para->timestep+".gda").c_str());
	this->read_gda(by,(para->path+"by_"+para->timestep+".gda").c_str());
	this->read_gda(bz,(para->path+"bz_"+para->timestep+".gda").c_str());
	this->read_gda(ez,(para->path+"ex_"+para->timestep+".gda").c_str());
	this->read_gda(ey,(para->path+"ey_"+para->timestep+".gda").c_str());
	this->read_gda(ez,(para->path+"ez_"+para->timestep+".gda").c_str());

	/*for (int i=0;i<length;i++)
	{
		ex[i]=2.;
		ey[i]=0;
		ez[i]=0;
		bx[i]=0;
		by[i]=2;
		bz[i]=0;
	}*/
}

/*--------------------------------------------------------------
File Reader
 ---------------------------------------------------------------*/
void EMfields::read_gda(float *data, const char* var)
{
	ifstream file;
	file.open(var, ios::in|ios::binary);
	if (file.is_open())
	{
		file.read(reinterpret_cast<char*>(data), para->nx*para->nz*sizeof(float));
		cout<<var<<" get loaded"<<endl;
	}
	file.close();
}


/*--------------------------------------------------------------
Return the EM field in givern location
 ---------------------------------------------------------------*/
void EMfields::querry(int loc, float *efield, float *bfield) const
{
	efield[0]=ex[loc];
	efield[1]=ey[loc];
	efield[2]=ez[loc];
	bfield[0]=bx[loc];
	bfield[1]=by[loc];
	bfield[2]=bz[loc];
}
/*--------------------------------------------------------------
Destructor
 ---------------------------------------------------------------*/
EMfields::~EMfields() {
	delete [] ex;
	delete [] ey;
	delete [] ez;
	delete [] bx;
	delete [] by;
	delete [] bz;
}

