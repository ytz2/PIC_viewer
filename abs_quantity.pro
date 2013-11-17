;+
; NAME:
;      abs_quantity
;
; PURPOSE:
;       calculate the |quantity|
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       abs_quantity(quantity,step)
;
; INPUTS:
;       quantity: 'ui','j' and etc
;       step: time step
;     
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), DEC 2012

FUNCTION ABS_QUANTITY,QUANTITY,STEP

xx=get_quantity(quantity+'x',step)
yy=get_quantity(quantity+'y',step)
zz=get_quantity(quantity+'z',step)

return, sqrt(xx*xx+yy*yy+zz*zz)

END
