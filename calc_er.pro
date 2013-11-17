
;+
; NAME:
;      CALC_ER
;
; PURPOSE:
;       Calculate the xyz component of E+VxB
; EXPLANATION:
;       This function is used to calculate the reconnection E field in the
;       simulation run
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       calc_ey,product,step
;
; INPUTS:
;       product: 'e': electron,'i': proton,'o':oxygen
;       component: 'x','y','z'
;       step:    time step
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Oct 2012.
;       Edited by Yanhua Liu Nov 2012, remove complex algorithm and
;       make use of cross_field.pro


FUNCTION CALC_ER,PRODUCT, COMPONENT,STEP


case component of
'x': e=get_quantity('ex',step)
'y': e=get_quantity('ey',step)
'z': e=get_quantity('ez',step)
endcase

return, e+cross_field('u'+product,'b',component,step)
END
