
;----------------------------------------
; Function to calculate the e cross b drift
;----------------------------------------

FUNCTION EBDRIFT, SPECIE,STEP, component 

btot=(get_quantity('absB',step))^2

if component eq 'x' then $
   data=cross_field('e','b','x',step)/btot
if component eq 'y' then $
   data=cross_field('e','b','y',step)/btot
if component eq 'z' then $
   data=cross_field('e','b','z',step)/btot
return, data
END

FUNCTION VTOTAL,SPECIE,STEP
vx=get_quantity('u'+specie+'x',step)
vy=get_quantity('u'+specie+'y',step)
vz=get_quantity('u'+specie+'z',step)
return, sqrt(vx*vx+vy*vy+vz*vz)
END
;----------------------------------------
; Function to calculate the e cross b product
;----------------------------------------

FUNCTION GDRIFT, SPECIE,STEP,xyz

btot=get_quantity('absB',step)

if xyz eq 'x' then begin
   data= get_quantity('by',step)*finite_DIFF(btot,/z)
endif

if xyz eq 'y' then begin
   data= get_quantity('bz',step)*finite_DIFF(btot,/x)- $
         get_quantity('bx',step)*finite_DIFF(btot,/z)
endif

if xyz eq 'z' then begin
   data= -get_quantity('by',step)*finite_DIFF(btot,/x)
endif
if specie eq 'e' then m=-1 ;electron q=-1
if specie eq 'i' then m=50
if specie eq 'o' then m=500

vpara=VELOCITY_PAR(specie,STEP)
vtot=vtotal(specie,step)
vperp_2=vtot*vtot-vpara*vpara
eperp=.5*m*vperp_2

data=data*eperp/(btot)^3
return, data
END


;----------------------------------------
; Function to calculate the dimagnetic drift
;----------------------------------------

FUNCTION DDRIFT, SPECIE,STEP,COMPONENET 

btot=get_quantity('absB',step)
n=get_quantity('n'+specie,step)
case COMPONENET of 
   'x':begin
      u1= DIV_P(STEP,'y',specie=specie)
      u2=DIV_P(STEP,'z',specie=specie)
      v1=get_quantity('bz',step)
      v2=get_quantity('by',step)
   end
   'y':begin
      u1=DIV_P(STEP,'z',specie=specie)
      u2=DIV_P(STEP,'x',specie=specie)
      v1=get_quantity('bx',step)
      v2=get_quantity('bz',step)
   end
   'z':begin
      u1=DIV_P(STEP,'x',specie=specie)
      u2=DIV_P(STEP,'y',specie=specie)
      v1=get_quantity('by',step)
      v2=get_quantity('bx',step)
   end
endcase
cross_product=u1*v1-u2*v2
charge=1
if specie eq 'e' then charge=-1

return, -cross_product/(charge*n*btot^2)
END

PRO drift_velocity, specie,step,component
eb_drift=EBDRIFT(specie,step,component)
g_drift=GDRIFT(specie,step,component)
d_drift=DDRIFT(specie,step,component)
v_perp=VELOCITY_PERP(specie,component,step)

ps_start,filename='/Users/yanhualiu/Desktop/test.ps'
plot_multi_quantity,[],step,$
                    extra_quantity={vperp:smooth(v_perp,5,/nan),$
                                    eb_drift:smooth(eb_drift,5,/nan),$
                                    g_drift:smooth(g_drift,5,/nan), $
                                    d_drift:smooth(d_drift,5,/nan)}, $
                    dim=[500,1500,-150,150], $
                    cbar={vperp:[-.5,.5],eb_drift:[-.5,.5],g_drift:[-2,2],d_drift:[-2,2]},/print
ps_end
stop
end
