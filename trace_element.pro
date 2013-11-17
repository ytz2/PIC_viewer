

FUNCTION POS2INDEX,X,Z
; accept two double value to convert to the index in the 2d data
; this requires the simulation info
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
zcenter=zmax/2.0
return,fix([X/xmax*nx,(1.0+Z/zcenter)*nz/2 ])
END


FUNCTION INDEX2POS,X,Z
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
zcenter=zmax/2.0
return,[x*(xmax/nx),(2.*z/nz-1.)*zcenter]
END


PRO TRACE_ELEMENT,STEP,SPECIE,START,xpath=xpath,zpath=zpath,limit=limit,xind=xind,zind=zind

common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory


n_start=n_elements(start)/2
seed=fltarr(2,n_start)
start=pos2index(start[0:n_start-1],start[n_start:2*n_start-1])
for i=0,n_start-1 do begin
   seed[0,i]=start[i]
   seed[1,i]=start[n_start+i]
endfor


data=fltarr(2,nx,nz)
vx_product='u'+specie+'x'
vz_product='u'+specie+'z'
data[0,*,*]=smooth(get_quantity(vx_product,step),10,/edge_truncate)
data[1,*,*]=smooth(get_quantity(vz_product,step),10,/edge_truncate)
particle_trace,data,seed,verts,conn,max_iterations=5000000,/integration

xind=[]
zind=[]
; Overplot the streamlines
i = 0
sz = SIZE(verts, /STRUCTURE)
WHILE (i LT sz.dimensions[1]) DO BEGIN
   nverts = conn[i]
 
   xIndices = verts[0, conn[i+1:i+nverts]]
   yIndices = verts[1, conn[i+1:i+nverts]]

   path=index2pos(reform(xindices),reform(yindices))
   xx=path[0:n_elements(xIndices)-1]
   zz=path[n_elements(xIndices):2*n_elements(xIndices)-1]
   if n_elements(start) gt 2 then $
   PLOTS, xx,zz,thick=2

   i += nverts + 1
   xind=[xind,round(reform(xindices))]
   zind=[zind,round(reform(yindices))]

  
ENDWHILE
nn=n_elements(xind)

temp_xind=[]
temp_zind=[]
for i=1,nn-1 do begin
   if (xind[i] eq xind[i-1]) and (zind[i] eq zind[i-1]) then continue
   temp_xind=[temp_xind,xind[i]]
   temp_zind=[temp_zind,zind[i]]
endfor

path=index2pos(reform(temp_xind),reform(temp_zind))
xx=path[0:n_elements(temp_xInd)-1]
zz=path[n_elements(temp_xInd):2*n_elements(temp_xInd)-1]
if keyword_set(limit) then begin
   ind=where(xx gt limit)
   xx=xx[ind]
   zz=zz[ind]
   temp_xind=temp_xind[ind]
   temp_zind=temp_zind[ind]
endif
if n_elements(start) eq 2 then $
plots,xx,zz
xind=temp_xind
zind=temp_zind
xpath=xx
zpath=zz

END
