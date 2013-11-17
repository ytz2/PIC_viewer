

FUNCTION POS2INDEX,X,Z
; accept two double value to convert to the index in the 2d data
; this requires the simulation info
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
zcenter=zmax/2.0
return,[X/xmax*nx,(1.0+Z/zcenter)*nz/2 ]
END


FUNCTION READ_TFILE,timestep,totalstep,n_oxygen


data=fltarr(n_oxygen*6,totalstep)
OPENR,99,"/Users/yanhualiu/Dropbox/viewer/tparticles/data/test"+strtrim(string(timestep),2)+"_3.dat"

READF,99,data
CLOSE,99 
print, "Reding Done"
return,data
END

FUNCTION READ_InitialFILE,n_oxygen


var=fltarr(6,n_oxygen)
OPENR,99,"/Users/yanhualiu/Dropbox/viewer/tparticles/initialization.txt"
READF,99,var
CLOSE,99 
return,var
END

FUNCTION GET_CUT,data,CUT

xx=[]
yy=[]
zz=[]
vx=[]
vy=[]
vz=[]
for i=0,2581 do begin
   xx=[xx,data[i*6,cut-1]]
   yy=[yy,data[i*6+1,cut-1]]
   zz=[zz,data[i*6+2,cut-1]]
   vx=[vx,data[i*6+3,cut-1]]
   vy=[vy,data[i*6+4,cut-1]]
   vz=[vz,data[i*6+5,cut-1]]
endfor
value=fltarr(6,n_elements(xx))
value[0,*]=xx
value[1,*]=yy
value[2,*]=zz
value[3,*]=vx
value[4,*]=vy
value[5,*]=vz
return,value
END

PRO SHOW_CUT,data,init,cut
cutme=get_cut(data,cut)
vx0=reform(init[3,*])
range=scale_vector(findgen(4),min(vx0),max(vx0))
xx=reform(cutme[0,*])
zz=reform(cutme[2,*])

ind1=where(vx0 gt range[0] and vx0 lt range[1])
ind2=where(vx0 gt range[1] and vx0 lt range[2])
ind3=where(vx0 gt range[2] and vx0 lt range[3])

plot,xx[ind1],zz[ind1],xrange=[0,2230],yrange=[-200,200],psym=1
oplot,xx[ind2],zz[ind2],color=1,psym=1
oplot,xx[ind3],zz[ind3],color=2,psym=1
END

PRO test_back,step

n_oxygen=2582L
data=read_tfile(step,5000L,n_oxygen)
init=read_initialfile(n_oxygen)
stop

for i=3000,0,-1 do show_cut,data,init,i

stop

opengda,step
dim=[0,2230,-500,500]

stop

END
