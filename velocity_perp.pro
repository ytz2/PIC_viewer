
;+
; NAME:
;      velocity_perp
;
; PURPOSE:
;       Calculate the xyz component of Vperp
; EXPLANATION:
;       This function calclate the perpendicular velocity to the B field
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       velocity_per,product,component,step
;
; INPUTS:
;       product: 'e': electron,'i': proton,'o':oxygen
;       component: 'x','y','z'
;       step:    time step
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Nov 2012.

FUNCTION VELOCITY_PERP,PRODUCT,COMPONENT,STEP

vpar=velocity_par(product,step)
btot=get_quantity('absB',step)

vi='u'+product+component
bi='b'+component

return, get_quantity(vi,step)-vpar*get_quantity(bi,step)/btot
END 
