
;+
; NAME:
;      cluster_observe
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
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), OCT 2013.
; Note: the reference sc is 1


PRO CLUSTER_OBSERVE, step,scale=scale


;------------------------------------
;parameter setup
;------------------------------------
sc_x=[0,-100,-110,-200]
sc_z=[0,150,-150,200]/2

delta=80/0.389757

sc_x=[0,-0.389757,-0.459570,-0.656885]*delta
sc_z=[0.,0.166978,-0.249097,0.388943]*delta
field=['ni','no','ne']
vectors=['b','ui'];'ue','ui','uo']



;set the scale of the vectors
if n_elements(scale) eq 0 then scale=5.

;orbit_click,xvalue=sc1_xx,yvalue=sc1_zz ; click to select the path
sc1_xx=[ 137.79105  ,     679.15567    ,   1518.7296]
sc1_zz=[ -125.87687  ,     11.106749   ,    12.106749 ]
sc2_xx=sc1_xx+sc_x[1]
sc2_zz=sc1_zz+sc_z[1]
sc3_xx=sc1_xx+sc_x[2]
sc3_zz=sc1_zz+sc_z[2]
sc4_xx=sc1_xx+sc_x[3]
sc4_zz=sc1_zz+sc_z[3]

for sc_index=1,4,1 do begin
   sc_name=strtrim(string(sc_index),2)
   print, "info=gen_path("+"sc"+sc_name+"_xx"+","+"sc"+sc_name+"_zz"+","+"scale)"
   void=execute("info=gen_path("+"sc"+sc_name+"_xx"+","+"sc"+sc_name+"_zz"+","+"scale)")   ; get the useful info, see gen_path.pro
 ;  stop
   ind_x=fix(info.nx)
   ind_z=fix(info.nz)
   x_orbit=info.x
   z_orbit=info.z

   plots,x_orbit,z_orbit,psym=2

   time=findgen(n_elements(x_orbit))*4.+time_double('2001-01-01')

   store_data,'sc'+sc_name+'_xorbit',$
              data={x:time,y:x_orbit} ,$
              dlim={panel_size:2,ytitle:'sc'+sc_name+" "+'X'}
   
   store_data,'sc'+sc_name+'_zorbit',$
              data={x:time,y:z_orbit} ,$
              dlim={panel_size:2,ytitle:'sc'+sc_name+" "+'Z'}
;---------------------------------------------------
; read field data
;---------------------------------------------------


   for i=0, n_elements(field)-1 do begin
      data=get_quantity(field[i],step)
      var=data[ind_x,ind_z]
      store_data,'sc'+sc_name+'_'+field[i], $
                 data={x:time,y:var} ,$
                 dlim={panel_size:2,ytitle:'sc'+sc_name+" "+field[i]}
   endfor

   for i=0, n_elements(vectors)-1 do begin
      datax=get_quantity(vectors[i]+'x',step)
      datay=get_quantity(vectors[i]+'y',step)
      dataz=get_quantity(vectors[i]+'z',step)
      varx=datax[ind_x,ind_z]
      vary=datay[ind_x,ind_z]
      varz=dataz[ind_x,ind_z]
      store_data,'sc'+sc_name+"_"+vectors[i], $
                 data={x:time,y:[[varx],[vary],[varz]]} ,$
                 dlim={panel_size:2,ytitle:'sc'+sc_name+" "+vectors[i]}
   endfor
endfor
END
