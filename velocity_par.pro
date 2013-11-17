;+
; NAME:
;      velocity_par
;
; PURPOSE:
;       Calculate the xyz component of Vpar
; EXPLANATION:
;       This function calclate the parallel velocity to the B field
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       velocity_per,product,step
;
; INPUTS:
;       product: 'e': electron,'i': proton,'o':oxygen
;       step:    time step
;       if xyz present then map v_par to x,y,z
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Nov 2012.

FUNCTION VELOCITY_PAR, PRODUCT,STEP,xyz=xyz

if n_elements(xyz) eq 0 then $
   return, dot_field('u'+product,'b',step)/get_quantity('absB',step)
case xyz of 
   'x': data= dot_field('u'+product,'b',step)*get_quantity('bx',step)/(get_quantity('absB',step))^2
   'y': data= dot_field('u'+product,'b',step)*get_quantity('by',step)/(get_quantity('absB',step))^2
   'z': data= dot_field('u'+product,'b',step)*get_quantity('bz',step)/(get_quantity('absB',step))^2
endcase
return, data

END
