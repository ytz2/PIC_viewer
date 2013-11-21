;+
; NAME:
;      CALC_EPOTENTIAL
;
; PURPOSE:
;       Calculate the electrostatic potential
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       CALC_EPOTENTIAL,STEP
;
; INPUTS:
;       step: time step
;     
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), April, 2013


FUNCTION CALC_EPOTENTIAL,STEP
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

;---------------------------------------------------------
;prepare for the vector container and parameters
;---------------------------------------------------------

dx=xmax/nx
dz=zmax/nz

ex=get_quantity('ex',step)
ez=get_quantity('ez',step)

pot=fltarr(nx,nz)

;set up reference value

pot[0,0]=0.
;---------------------------------------------------------
;calculattion start
;---------------------------------------------------------
for iz=0,nz-1 do begin
   if (iz gt 0) then $
      pot[0,iz]=pot[0,iz-1]-ez[0,iz-1]*dz
   for ix=1,nx-1 do begin
      pot[ix,iz]=pot[ix-1,iz]-ex[ix-1,iz]*dx
   endfor
endfor



return,pot

END
