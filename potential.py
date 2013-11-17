#!/usr/bin/env python
import numpy as np
from pylab import *
import sys
from matplotlib.colors import LogNorm
import matplotlib.pyplot as plt
import math

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

def poisson_dir(f):
    #http://hep.physics.indiana.edu/~hgevans/p411-p610/material/10_pde_bound/ft.html
    #dirichlet boundary condition for both boundary
    F = np.imag(np.fft.fft2(f))
    dx=lx/nx
# get the wavenumbers -- we need these to be physical, so multiply by Nx
    kx = nx*np.fft.fftfreq(nx)
    kz = nz*np.fft.fftfreq(nz)

# make 2-d arrays for the wavenumbers
    kx2d = np.repeat(kx, nz)
    kx2d.shape = (nx, nz)

    kz2d = np.repeat(kz, nx)
    kz2d.shape = (nz, nx)
    kz2d = np.transpose(kz2d)
    kx2d[0,0]=np.nan
    kz2d[0,0]=np.nan
    F = 0.5*F*dx*dx/np.abs((np.cos(2.0*math.pi*kx2d/nx)+np.cos(2.0*math.pi*kz2d/nz) - 2.0))
    F[0,0]=0.
# transform back to real space
    fsolution = np.real(np.fft.ifft2(F))
    return fsolution


def show_me(data,vmin=None,vmax=None,tlt=None,ay=None):
    figure(figsize=(13,12))
    clf()
    title(tlt)
    im=plt.imshow(data,origin='lower',extent=[0,lx,-lz/2,lz/2],vmin=vmin,vmax=vmax)
    if ay:
        over=read_data('ay',ay)
        contour(over,origin='lower',levels=np.linspace(np.min(over),np.max(over),16,endpoint=True),
                colors='black', linewidth=.5,extent=[0,lx,-lz/2,lz/2])
    xlabel('X')
    ylabel('Z')
    cbar=colorbar(im,use_gridspec=True)
    show()

if __name__ == '__main__':
    step=146240
    rho=read_data('ni',step)+read_data('no',step)-read_data('ne',step)
    phi=poisson_dir(-rho)
    show_me(phi,ay=step)
