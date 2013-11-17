

FUNCTION POS2INDEX,X,Z
; accept two double value to convert to the index in the 2d data
; this requires the simulation info
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
zcenter=zmax/2.0
return,long([X/xmax*nx,(1.0+Z/zcenter)*nz/2 ])
END


FUNCTION READ_TFILE,timestep,totalstep

n_electron=1L
n_proton=1L
n_oxygen=6L

data=fltarr((n_electron+n_proton+n_oxygen)*6,totalstep)
OPENR,99,"/Users/yanhualiu/Dropbox/viewer/tparticles/data/test"+strtrim(string(timestep),2)+"_2.dat"
READF,99,data
CLOSE,99 
print, "Reding Done"
return,data
END


FUNCTION READ_QUANTITY,quantity,pathx,pathz,step=step
if not keyword_set(step) then step=146240

quant=get_quantity(quantity,step)
cut=n_elements(pathx)
temp=reform(pos2index(reform(pathx),reform(pathz)))
nx=reform(temp[0:cut-1])
nz=reform(temp[cut:2*cut-1])

return,reform(quant[nx,nz])
END


FUNCTION INTERG_TIME,QUANTITY,DT,normalize=normalize

if not keyword_set(normalize) then normalize=500
data=fltarr(n_elements(quantity))
data[0]=0.

for i=1,n_elements(quantity)-1 do begin
   data[i]=data[i-1]+(quantity[i-1]*dt)/normalize
endfor

return,data
END

FUNCTION INTERG_PATH,QUANTITY,mypath

dx=reform(mypath[1:n_elements(path)-1]-mypath[0:n_elements(mypath)-2])
dx=[dx,dx[n_elements(dx)-1]]
phi=fltarr(n_elements(mypath))
phi[0]=0.
for k=1,n_elements(mypath)-1 do begin
   phi[k]=phi[k-1]+quantity[k-1]*dx[k]
endfor

return,phi
end

PRO test_particle,specie,no,step=step

data=read_tfile(step,1600000L)

cut=1000000
cut1=850000
cut2=1000000
cut3=1200000

dt=.1/sqrt(4.*!pi)

dtwpo=dt*0.5/(!pi*2*500)
va=0.08
b0=0.5


nh=0.0413872
no=0.0239593
b0=0.299664
va=b0/sqrt(nh*50+no*500)


opengda,step
dim=[400,1300,-250,250]


;pot=calc_epotential(step)
;plot_contour,'Potential',step,dim=dim,indata=pot,/print
;plot_contour,'Hall Efield',step,dim=dim,indata=smooth(get_quantity('ez',step)/(b0*va),5),bar_low=-3,bar_up=3

!p.charsize=2.
thm_init,/reset


x1=reform(data[2*6,*]) & z1=reform(data[2*6+2,*])
x2=reform(data[3*6,*]) & z2=reform(data[3*6+2,*])
x3=reform(data[4*6,*]) & z3=reform(data[4*6+2,*])
x4=reform(data[5*6,*]) & z4=reform(data[5*6+2,*])
x5=reform(data[6*6,*]) & z5=reform(data[6*6+2,*])
x6=reform(data[7*6,*]) & z6=reform(data[7*6+2,*])


regstop=700
plots,x1(where(x1 ge regstop)),z1(where(x1 ge regstop)),color=4
plots,x2(where(x2 ge regstop)),z2(where(x2 ge regstop)),color=4

plots,x3(where(x3 ge regstop)),z3(where(x3 ge regstop)),color=2
plots,x4(where(x4 ge regstop)),z4(where(x4 ge regstop)),color=2

plots,x5(where(x5 ge regstop)),z5(where(x5 ge regstop)),color=3
plots,x6(where(x6 ge regstop)),z6(where(x6 ge regstop)),color=3
;ps_end
;stop

i=6


xx=reform(data[i*6,*])
yy=reform(data[i*6+1,*])
zz=reform(data[i*6+2,*])
ind=where(xx ge regstop)
xx=xx[ind]
yy=yy[ind]
zz=zz[ind]
vx=reform(data[i*6+3,ind])
vy=reform(data[i*6+4,ind])
vz=reform(data[i*6+5,ind])
time=findgen(n_elements(xx))*dtwpo
vtot=sqrt(vx^2.+vy^2.+vz^2.)
  
ex= READ_QUANTITY('ex',xx,zz)
ey= READ_QUANTITY('ey',xx,zz)
ez= READ_QUANTITY('ez',xx,zz)

bx= READ_QUANTITY('bx',xx,zz)
by= READ_QUANTITY('by',xx,zz)
bz= READ_QUANTITY('bz',xx,zz)


lorenz_x=(vy*bz-vz*by)
lorenz_y=(vz*bx-vx*bz)
lorenz_z=(vx*by-vy*bx)

btot=sqrt(bx^2.+by^2.+bz^2.)
ebx=(ey*bz-ez*by)/btot^2.
eby=(ez*bx-ex*bz)/btot^2.
ebz=(ex*by-ey*bx)/btot^2.


ohm_x=ex+lorenz_x
ohm_y=ey+lorenz_y
ohm_z=ez+lorenz_z

ex_t=INTERG_TIME(ex,dt)
ey_t=INTERG_TIME(ey,dt)
ez_t=INTERG_TIME(ez,dt)


ps_start,'profile.ps',/land
plot,[0],[0],xrange=[0,5],yrange=[-1,1.2],xtitle='t (1/w!lco!n)',ytitle='v/v!LAlfven!n'
oplot,time,vx/va,color=6
oplot,time,vy/va,color=1 
oplot,time,vz/va,color=2
oplot,time,smooth(ebx/va,6000),color=6,linestyle=4
oplot,time,smooth(eby/va,6000),color=1,linestyle=4
oplot,time,smooth(ebz/va,6000),color=2,linestyle=4

ps_end

lorentzxt=INTERG_TIME(lorenz_x,dt)
lorentzyt=INTERG_TIME(lorenz_y,dt)
lorentzzt=INTERG_TIME(lorenz_z,dt)


energy=1/2.*500*vtot*vtot
phix=INTERG_PATH(ex,xx)
phiy=INTERG_PATH(ey,yy)
phiz=interg_path(ez,zz)
;!p.multi=[0,1,4]
plot,energy
oplot,phix+phiz,color=1
oplot,phiy,color=2
stop

END
