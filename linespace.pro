

;+
; NAME:
;       LINESPACE
;
; PURPOSE:
;       Return X or Z array of locations
;
; CATEGORY:
;       Utitlity
;
; CALLING SEQUENCE:
;       result=linespace(/x)
;
; Keywords:
;       X: if set return x array
;       Z: if set return z array
;       dim: if set return x or z array in given domain
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Oct 2012.



FUNCTION LINESPACE,dim=dim,x=x,z=z


common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

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

if keyword_set(z) then $
  return, v.zmin + ((v.zmax-v.zmin)/lz)*(findgen(lz)+0.5)
if keyword_set(x) then $
  return, ((v.xmax-v.xmin)/lx)*(findgen(lx)+0.5) + v.xmin

return,0
END
