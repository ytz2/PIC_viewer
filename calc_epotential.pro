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
;       Modified by: Yanhua Liu, May 20, 2013, updated with poisson solver
;       Modified by: Yanhua Liu, May 23, 2013, change the periodic
;       solver to open boundary solver







FUNCTION CALC_EPOTENTIAL,STEP
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

; Get the charge density from Quantity Files
rho=get_quantity('ni',step)+get_quantity('no',step)-get_quantity('ne',step)

; Solve The Poisson Equation
dx=xmax/nx
;result=poisson_open_boundary(rho,nx,nz,xmax,zmax)
result=poisson(-rho,dx)
return, result
END
