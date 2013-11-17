
;+
; NAME:
;      simulate_observe
;
; PURPOSE:
;      GUI to push user to select a virtual SC path and save the
;      corresponding data to tplot files
;
; CATEGORY:
;       Utility
;
;
; INPUTS:
;       step: time step
; Option Input:
;       scale: seperation distance between points
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.


PRO SIMULATE_OBSERVE, step,scale=scale

;set the scale of the vectors
if n_elements(scale) eq 0 then scale=5.

orbit_click,xvalue=xx,yvalue=zz ; click to select the path
info=gen_path(xx,zz,scale) ; get the useful info, see gen_path.pro

ind_x=fix(info.nx)
ind_z=fix(info.nz)
x_orbit=info.x
z_orbit=info.z

plots,x_orbit,z_orbit,psym=2

time=findgen(n_elements(x_orbit))*4.+time_double('2001-01-01')

store_data,'xorbit',$
           data={x:time,y:x_orbit} ,$
           dlim={panel_size:2,ytitle:'X'}

store_data,'zorbit',$
           data={x:time,y:z_orbit} ,$
           dlim={panel_size:2,ytitle:'Z'}
;---------------------------------------------------
; read field data
;---------------------------------------------------
field=['ni','no','ne']
vectors=['b','ui'];'ue','ui','uo']

for i=0, n_elements(field)-1 do begin
   data=get_quantity(field[i],step)
   var=data[ind_x,ind_z]
   store_data,field[i], $
              data={x:time,y:var} ,$
              dlim={panel_size:2,ytitle:field[i]}
endfor

for i=0, n_elements(vectors)-1 do begin
   datax=get_quantity(vectors[i]+'x',step)
   datay=get_quantity(vectors[i]+'y',step)
   dataz=get_quantity(vectors[i]+'z',step)
   varx=datax[ind_x,ind_z]
   vary=datay[ind_x,ind_z]
   varz=dataz[ind_x,ind_z]
   store_data,vectors[i], $
              data={x:time,y:[[varx],[vary],[varz]]} ,$
              dlim={panel_size:2,ytitle:vectors[i]}
endfor

END
