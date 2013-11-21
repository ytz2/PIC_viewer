/*
 * TparticleMgr.cpp
 *
 *  Created on: Dec 8, 2012
 *      Author: yanhua
 */

#include "TparticleMgr.h"


/***************************************************
 * constructor
 ***************************************************/
TparticleMgr::TparticleMgr()
{
	para=new Parameter();

	em=new EMfields(para);

	runner= new Runner(para,em);

	for (int i=0;i<para->ne;i++)
		group.push_back(new Particle(para,para->emass));
	for (int i=0;i<para->ni;i++)
		group.push_back(new Particle(para,para->imass));
	for (int i=0;i<para->no;i++)
		group.push_back(new Particle(para,para->omass));

}

/***************************************************
 * destructor
 ***************************************************/
TparticleMgr::~TparticleMgr()
{
	delete para;
	delete em;
	delete runner;

	while(!group.empty())
	{
		delete group.back();
		group.pop_back();
	}
}

/***************************************************
 * Print to files
 ***************************************************/
void TparticleMgr::print(int step, ofstream& out)
{
	if (step%para->stepPrint!=0)
		return;
//	ofstream out;
//	int tag=step/para->stepPrint;
//	char name[10];
//	sprintf(name,"%05d%s",tag,".dat");
//	string myname=string(name);
//	myname="/home/yanhua/Desktop/test/"+myname;
//	out.open(myname.c_str());
	for (it iter=group.begin();iter!=group.end();++iter)
		out<<*(*iter);
	out<<endl;
//	out.close();
}

/***************************************************
 * monitor simulations
 ***************************************************/
void TparticleMgr::monitor(int step)
{
	if (step%para->stepPrint!=0)
		return;
	cout<<"        STEP   "<<step<<endl;
	cout<< *(group[0])<<endl;
}

/***************************************************
 * Run the simulation and manage group of particles
 ***************************************************/
void TparticleMgr::run()
{
	it iter;
	ofstream out;
	out.open(para->saveto.c_str());
	this->initialize();
	for(int step=0;step<para->stepMax;step++)
	{
		monitor(step);
		print(step,out);
		for (iter=group.begin();iter!=group.end();++iter)
		{
		  runner->run(*iter,step);
		}
	}
	out.close();
}

/***************************************************
 * Set up initial conditions for the run from file
 ***************************************************/

void TparticleMgr::initialize()
{
	ifstream in;
	in.open(para->initialization.c_str());
	float *buffer=new float[6*(para->ne+para->ni+para->no)];
	float *temp=buffer;

	while (!in.eof())
	{
		in>>*temp;
		temp++;
	}
	temp=buffer;
	in.close();
	for (int i=0;i<para->ne;i++)
	{
		(group[i])->setX(temp);
		(group[i])->setV(temp+3);
		temp+=6;
	}

	for (int i=para->ne;i<para->ne+para->ni;i++)
	{
		(group[i])->setX(temp);
		(group[i])->setV(temp+3);
		temp+=6;
	}
	for (int i=para->ne+para->ni;i<para->ne+para->ni+para->no;i++)
	{
		(group[i])->setX(temp);
		(group[i])->setV(temp+3);
		temp+=6;
	}
	delete buffer;
	temp=NULL;
}
