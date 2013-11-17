;+
; NAME:
;      DOT_FIELD
;
; PURPOSE:
;       Calculate the DOT product A.B
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       dot_field,var1,var2,step
;
; INPUTS:
;       VAR1: A
;       var2: B
;       step: time step
;     
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), NOV 2012

FUNCTION DOT_FIELD,VAR1,VAR2,STEP

print,'################################'
print, var1+' is choosen as A'
print, var2+' is choosen as B'
print, 'return dot product A.B'
print,'################################'

ax=get_quantity(var1+'x',step)
ay=get_quantity(var1+'y',step)
az=get_quantity(var1+'z',step)
bx=get_quantity(var2+'x',step)
by=get_quantity(var2+'y',step)
bz=get_quantity(var2+'z',step)

return, ax*bx+ay*by+az*bz
END
