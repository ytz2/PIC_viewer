#!/usr/bin/env python
import numpy as np
from pylab import *
import sys
from matplotlib.colors import LogNorm
import matplotlib.pyplot as plt


path='/Volumes/Liu/oxygen-run1/data/'
nx=7168
nz=7168
lx=2236.07
lz=2236.07
def read_data(name,tindex):
    # read specie distribution function at (i0,j0) block
        
    fln=path+'T.'+str(tindex)+'/'+name+'_'+str(tindex)+'.gda'
    f=open(fln)
    dist=np.fromstring(f.read(),dtype=np.dtype('f'),count=nx*nz)
    f.close()
    
    dist=np.reshape(dist,(nx,nz))
    return dist


if __name__ == '__main__':
    step=146240
    figure(figsize=(13,12))
    clf()
    data=read_data('by',step)
    ay=read_data('ay',step)
    im=plt.imshow(np.flipud(data),extent=[0,lx,-lz/2,lz/2])
    contour(np.flipud(ay), levels=np.linspace(np.min(ay),np.max(ay),16,endpoint=True),colors='black', linewidth=.5,extent=[0,lx,-lz/2,lz/2])
    #C = contour(dist2D,12, colors='black', linewidth=.5,norm=LogNorm(),levels=levels)
    cbar=colorbar(im)
    show()
