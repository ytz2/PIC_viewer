#!/usr/bin/env python
import matplotlib
#matplotlib.use('PS')
import numpy as np
from numpy import linalg as LA
from pylab import *
import sys
from matplotlib.colors import LogNorm
import matplotlib.pyplot as plt

# example ./distplay_distr tindex i0 j0 e
# no check, no error catching. If any problem occurs,
# contact yhliu@atlas.sr.unh.edu

class distribution(object):

    def __init__(self,i0,j0,specie,tindex=146240,delta=1):
        self.tindex=tindex
        self.path='/Volumes/Liu/oxygen-run1/distributions/dist'+str(tindex)+'/'
        self.specie=specie
        fln=self.specie+'particle.%i.dist.%i.0.%i.bin' % (self.tindex,i0,j0)
        f=open(self.path+fln)
        self.vmax=np.fromstring(f.read(8*3),dtype=np.dtype('d'),count=3)
        self.nv=np.fromstring(f.read(4*3),dtype=np.dtype('i'),count=3)
        f.close()
        self.vx=-self.vmax[0]+2*self.vmax[0]/(self.nv[0]-1)*np.arange(0,self.nv[0]).astype('float')
        self.vy=-self.vmax[1]+2*self.vmax[1]/(self.nv[1]-1)*np.arange(0,self.nv[1]).astype('float')
        self.vz=-self.vmax[2]+2*self.vmax[2]/(self.nv[2]-1)*np.arange(0,self.nv[2]).astype('float')
        self.i0=i0
        self.j0=j0
  
        if specie=='e':
            self.dist=self._read_dist(i0,j0)
        elif specie=='H' or specie=='O':
            self.dist=np.zeros(shape=(self.nv[0],self.nv[1],self.nv[2]))
            for i in np.arange(i0-delta,i0+delta+1):
                for j in np.arange(j0-delta,j0+delta+1):
                    self.dist=self.dist+self._read_dist(i,j)
        self.dist_xy=None
        self.dist_xz=None
        self.dist_yz=None


    def calc_dist(self,phase=False,angle=None,mag=False,subtract=False):

        if mag and subtract:
            raise
        if mag:
            self._trans_mag()
        
        if not angle:
            self.dist_xy = np.round(np.sum(self.dist,axis=2))
            self.dist_xz = np.round(np.sum(self.dist,axis=1))
            self.dist_yz = np.round(np.sum(self.dist,axis=0))
        else:
            self._angle_sum(angle)

            #subtract the exb/b**2 drift
        if subtract:
            self._subtract_eb()
                    
        if phase :
            dvx=self.vmax[0]/(self.nv[0]-1.)
            dvy=self.vmax[1]/(self.nv[1]-1.)
            dvz=self.vmax[2]/(self.nv[2]-1.)
            norm_factor=self.dist.sum()*dvx*dvy*dvz
            self.dist_xy=self.dist_xy/norm_factor
            self.dist_xz=self.dist_xz/norm_factor
            self.dist_yz=self.dist_yz/norm_factor           
            
        self.dist_xy[self.dist_xy==0]=np.nan
        self.dist_xz[self.dist_xz==0]=np.nan
        self.dist_yz[self.dist_yz==0]=np.nan

    def plot_contourf(self,subplt,lim=None,mag=False,va=None):

        vx=self.vx#/0.0798
        vy=self.vy#/0.0798
        vz=self.vz#/0.0798
        dist2D_xy=self.dist_xy
        dist2D_xz=self.dist_xz
        dist2D_yz=self.dist_yz

        subplot(subplt[0],subplt[1],subplt[2])
        title(self.specie+' DF')

        label=[r'$V_x$',r'$V_y$',r'$V_z$']
        if va:
            label=[r'$v_x/v_a$',r'$v_y/v_a$',r'$v_z/v_a$']
        if mag:
            label=[r'$V_\parallel$',r'$V_{\perp1}$',r'$v_{\perp2}$']
        self._do_contour(vx,vy,dist2D_xy.transpose(),label[0],label[1],lim=lim,va=va)
       
        subplot(subplt[0],subplt[1],subplt[2]+1)
        self._do_contour(vx,vz,dist2D_xz.transpose(),label[0],label[2],lim=lim,va=va)
        
        subplot(subplt[0],subplt[1],subplt[2]+2)
        self._do_contour(vy,vz,dist2D_yz.transpose(),label[1],label[2],lim=lim,va=va)

    def _subtract_eb(self):
        data=np.genfromtxt('em_block_%i.txt' % self.tindex,unpack=True).reshape((6,64,64))
        bfield=data[0:3,self.i0,self.j0]
        efield=data[3:6,self.i0,self.j0]
        bnorm=LA.norm(bfield)
        vdrift=np.cross(efield,bfield)/(bnorm*bnorm)
        self.vx=self.vx-vdrift[0]
        self.vy=self.vy-vdrift[1]
        self.vz=self.vz-vdrift[2]
        
    def _trans_mag(self):
        data=np.genfromtxt('em_block_%i.txt' % self.tindex,unpack=True).reshape((6,64,64))
        bfield=data[0:3,self.i0,self.j0]
        efield=data[3:6,self.i0,self.j0]
        x1=bfield/LA.norm(bfield) # B parallel
        x2=np.cross(efield,bfield)/LA.norm(np.cross(efield,bfield)) # ExB
        x3=np.cross(x1,x2) # BX(ExB)
        dist=np.zeros(shape=(self.nv[0],self.nv[1],self.nv[2]),order='F')

        vx=self.vx
        vy=self.vy
        vz=self.vz

        new_max=LA.norm(self.vmax)
        self.vx=np.linspace(-new_max,new_max,self.nv[0])
        self.vy=np.linspace(-new_max,new_max,self.nv[1])
        self.vz=np.linspace(-new_max,new_max,self.nv[2])
        
        dvx=2*new_max/(self.nv[0]-1)
        dvy=2*new_max/(self.nv[1]-1)
        dvz=2*new_max/(self.nv[2]-1)

        #################

        vx1=vx*x1[0]
        vy1=vy*x1[1]
        vz1=vz*x1[2]
        vx2=vx*x2[0]
        vy2=vy*x2[1]
        vz2=vz*x2[2]
        vx3=vx*x3[0]
        vy3=vy*x3[1]
        vz3=vz*x3[2]

        for i in range(self.nv[0]):
            for j in range(self.nv[1]):
                for k in range(self.nv[2]):
                    ii=int((vx1[i]+vy1[j]+vz1[k])/dvx+49.5)
                    jj=int((vx2[i]+vy2[j]+vz2[k])/dvx+49.5)
                    kk=int((vx3[i]+vy3[j]+vz3[k])/dvx+49.5)
                    dist[ii,jj,kk]=dist[ii,jj,kk]+self.dist[i,j,k]
        self.dist=dist
        ##################

        #print 'Changeing coordinate system to (B,ExB,Bx(ExB))'
        
        #for i,Vx in enumerate(vx):
        #    for j,Vy in enumerate(vy):
        #        for k,Vz in enumerate(vz):
        #            xx=int(np.dot([Vx,Vy,Vz],x1)/dvx+49.5)
        #            yy=int(np.dot([Vx,Vy,Vz],x2)/dvy+49.5)
        #            zz=int(np.dot([Vx,Vy,Vz],x3)/dvz+49.5)
        #            dist[xx,yy,zz]=dist[xx,yy,zz]+self.dist[i,j,k]

        #self.dist=dist
                    
    def _angle_sum(self,angle):
        xy=np.zeros(shape=(self.nv[0],self.nv[1]))
        xz=np.zeros(shape=(self.nv[0],self.nv[2]))
        yz=np.zeros(shape=(self.nv[1],self.nv[2]))

        for i in range(100):
            for j in range(100):
                delta=((i-49.5)**2.+(j-49.5)**2.)**0.5*np.tan(np.pi/180.*angle)
                start=int(49.5-delta)
                end=int(49.5+delta)+1
                if start<0:
                    start=0
                if end>99:
                    end=100
                xy[i,j]=np.sum(self.dist[i,j,start:end])
                xz[i,j]=np.sum(self.dist[i,start:end,j])
                yz[i,j]=np.sum(self.dist[start:end,i,j])

        self.dist_xy=np.round(xy)
        self.dist_xz=np.round(xz)
        self.dist_yz=np.round(yz)
                

    def _read_dist(self,i0,j0):
        # read specie distribution function at (i0,j0) block
        
        fln=self.specie+'particle.%i.dist.%i.0.%i.bin' % (self.tindex,i0,j0)
        f=open(self.path+fln)

        vmax=np.fromstring(f.read(8*3),dtype=np.dtype('d'),count=3)
        nv=np.fromstring(f.read(4*3),dtype=np.dtype('i'),count=3)
        
        grids=nv[0]*nv[1]*nv[2]
        dist=np.fromstring(f.read(),dtype=np.dtype('d'),count=grids)
        f.close()

        dist=np.reshape(dist,(nv[0],nv[1],nv[2]),order="F")
        return dist
    
    def _calc_lim(self,im):
        
        p = im.collections[0].get_paths()[0]
        v = p.vertices
        x = max(np.abs(v[:,0]))
        y = max(np.abs(v[:,1]))
        lim=2*max([x,y])
        if lim>self.vmax[0]:
            lim=self.vmax[0]
        return lim
    
    def _do_contour(self,xx,yy,dist2D,xlab,ylab,lim=None,linear=False,va=None):
        if va:
            xx=xx/va
            yy=yy/va
        if linear==False:
            lev_exp = np.arange(np.floor(np.log10(np.nanmin(dist2D))),np.ceil(np.log10(np.nanmax(dist2D))+0.5),0.5)
            levels = np.power(10, lev_exp)
  
            #levels=np.logspace(np.floor(np.log10(np.nanmin(dist2D))),np.ceil(np.log10(np.nanmax(dist2D))),10,endpoint=True)
            #grid(True)
            im=contourf(xx,yy,dist2D,levels=levels,norm=LogNorm())
            C = contour(xx, yy, dist2D,12, colors='black', linewidth=.5,norm=LogNorm(),levels=levels)
        if linear==True:
            levels=np.round(np.linspace(1,np.nanmax(dist2D),num=12,endpoint=True))
            #grid(True)
            im=contourf(xx,yy,dist2D,levels=levels)
            C = contour(xx, yy, dist2D, levels=levels,colors='black', linewidth=.5)


        #c1=Circle((0.,0.),.08,fill=False)
        #c2=Circle((0.,0.),.04,fill=False)
        #c4=Circle((0.,0.),.16,fill=False)
        #c3=Circle((0.,0.),.2236,fill=False)
        #gca().add_artist(c1)
        #gca().add_artist(c2)
        #gca().add_artist(c3)
        #gca().add_artist(c4)
        if not lim:
            lim=self._calc_lim(C)
        if va:
            lim=lim/va
        plot([-lim,lim],[0.,0.],'--',color='b')
        plot([0.,0.],[-lim,lim],'--',color='b')
        xlabel(xlab)
        ylabel(ylab)
        xlim([-lim,lim])
        ylim([-lim,lim])
        #gca().xaxis.get_major_locator()._nbins=4 
        cbar=colorbar(im,use_gridspec=True)



        
if __name__=='__main__':


    i0 = int(sys.argv[1]);
    j0 = int(sys.argv[2]);
    tindex=int(float(sys.argv[3]))
    dist_e=distribution(i0,j0,'e',tindex=tindex)
    dist_h=distribution(i0,j0,'H',delta=0,tindex=tindex)
    dist_o=distribution(i0,j0,'O',delta=0,tindex=tindex)

    #dist_e.calc_dist()
    #dist_h.calc_dist()
    #dist_o.calc_dist()

    mag=False
    subtract=False
    if 'mag' in sys.argv:
        mag=True
    if 'subtract' in sys.argv:
        substract=True

    va=0.0798
    formats='ps'

    
    print 'Generating DF'
    dist_e.calc_dist(angle=20.,mag=mag,subtract=subtract)
    dist_h.calc_dist(angle=20.,mag=mag,subtract=subtract)
    dist_o.calc_dist(angle=20.,mag=mag,subtract=subtract)
    #dist_e.calc_dist(mag=mag,subtract=subtract)
    #dist_h.calc_dist(mag=mag,subtract=subtract)
    #dist_o.calc_dist(mag=mag,subtract=subtract)

    if formats == 'ps' and save != None:
        figure(figsize=(13,12))
    else:
        figure(figsize=(13,12))
    clf()
    suptitle('i='+str(i0)+','+'j='+str(j0), fontsize=14)
    dist_e.plot_contourf([3,3,1],lim=0.75,mag=mag,va=va)
    dist_h.plot_contourf([3,3,4],lim=0.25,mag=mag,va=va)
    dist_o.plot_contourf([3,3,7],lim=0.25,mag=mag,va=va)
    tight_layout()
    subplots_adjust(bottom=0.06,top=0.94,hspace=0.3)
    
    if 'save' in sys.argv:
        savefig(sys.argv[-1]+'i_%i_j_%i' % (i0,j0)+'.'+formats,format=formats)
    else:
        show()
    close('all')
