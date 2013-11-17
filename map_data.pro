
;+
; NAME:
;      MAP_DATA
;
; PURPOSE:
;      return the data at the xcut (zcut) of given domain sized
;      quantity or data
;
; CATEGORY:
;       Utitlity
;
;
; INPUTS:
;       var: quantity.gda, if it is set, the data will not take effect
;       step: time step
;       data: 2d array data got by get_quantity, conflict with var
;       xcut: cut at x=xcut de location
;       zcut: cut at z=zcut de location conflict with xcut
;       dim: domain size, if not set use default 
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note: it will not check if the given coordinate is out of bound

FUNCTION MAP_DATA,var=var,step=step,data=data,xcut=xcut,zcut=zcut,DIM=DIM
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

if n_elements(var) ne 0 and n_elements(step) ne 0 then $
   temp=get_quantity(var,step)
if n_elements(data) ne 0 then $
   temp=data

zcenter=zmax/2.0
v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:1,contours:24}

if (n_elements(dim) ne 0) then begin
   v.xmin=dim[0]
   v.xmax=dim[1]
   v.zmin=dim[2]
   v.zmax=dim[3]
endif

imin=fix(v.xmin/xmax*nx)
imax=fix(v.xmax/xmax*nx)-1
lx = imax-imin +1 
jmin = fix((1.0+v.zmin/zcenter)*nz/2)
jmax = nz-1-fix((1.0-v.zmax/zcenter)*nz/2)
lz = jmax-jmin +1 

if n_elements(dim) ne 0 then $
   temp = temp(imin:imax,jmin:jmax)


if n_elements(xcut) ne 0 then begin
   slice = fltarr(lz)
   islice=fix((xcut-v.xmin)/(v.xmax-v.xmin)*float(lx)-0.5)
   for j=0,lz-1 do begin
      slice(j) = temp(islice,j)
   endfor
endif

if n_elements(zcut) ne 0 then begin
   jslice=fix((zcut-v.zmin)/(v.zmax-v.zmin)*float(lz)-0.5)
   slice = fltarr(lx)
   for i=0,lx-1 do begin
      slice(i) = temp(i,jslice)
   endfor
endif

return,slice
END
