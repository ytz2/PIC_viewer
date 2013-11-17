
;+
; NAME:
;      CROSS_FIELD
;
; PURPOSE:
;       Calculate the xyz component of AXB
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       CROSS_FIELD,A,B,x(yz),STEP
;
; INPUTS:
;       VAR1: A
;       var2: B
;       step: time step
;       component: x,y,z
;     
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), NOV 2012

FUNCTION CROSS_FIELD,VAR1,VAR2,COMPONENT,STEP

print,'################################'
print, var1+' is choosen as A'
print, var2+' is choosen as B'
print, 'return '+component+' of AxB'
print,'################################'

case component of
'x': begin
   ai=var1+'y'
   aj=var1+'z'
   bi=var2+'z'
   bj=var2+'y'
end
'y': begin
   ai=var1+'z'
   aj=var1+'x'
   bi=var2+'x'
   bj=var2+'z'
end

'z': begin
   ai=var1+'x'
   aj=var1+'y'
   bi=var2+'y'
   bj=var2+'x'
end
endcase
ai_data=get_quantity(ai,step)
aj_data=get_quantity(aj,step)
bi_data=get_quantity(bi,step)
bj_data=get_quantity(bj,step)

return, ai_data*bi_data-aj_data*bj_data

END
