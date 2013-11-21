;+
; NAME:
;      finite_diff
;
; PURPOSE:
;       Calculate the finite difference in x,z direction
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       finite_diff,product,step,/x( or /z)
;
; INPUTS:
;       step: time step
;       product: scalar name
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), April, 2013


FUNCTION FINITE_DIFF,PRODUCT,STEP,X=X,Z=Z
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

;------------------------------------------
;prepare
;------------------------------------------
var=get_quantity(product,step)
dx=xmax/nx
dz=zmax/nz
fdiff=fltarr(nx,nz)

;------------------------------------------
;calc
;------------------------------------------
if keyword_set(x) and not keyword_set(z) then begin
   for i=1,nx-1 do begin
      fdiff[i,*]=(var[i,*]-var[i-1,*])/dx
   endfor
   fdiff[0,*]=fdiff[1,*] ;artificial
endif

if keyword_set(z) and not keyword_set(x) then begin
   for i=1,nz-1 do begin
      fdiff[*,i]=(var[*,i]-var[*,i-1])/dz
   endfor
   fdiff[*,0]=fdiff[*,1] ;artificial
endif

if not keyword_set(z) and not keyword_set(x) then return,-1

return,fdiff
END
