;+
; NAME:
;      PARA_POTENTIAL
;
; PURPOSE:
;       Calculate the Egedal Parallel Potential
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       para_potential,step
;
; INPUTS:
;       step: time step
;     
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), June, 2013
;     

PRO PARA_POTENTIAL,step
abs_B=get_quantity('absB',step)
epara=dot_field('e','b',step)/abs_B
bx=get_quantity('bx',step)
by=get_quantity('by',step)
bz=get_quantity('bz',step)
stop
END
