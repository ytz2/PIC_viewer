
FUNCTION get_cbar,product
  x=0 &y=0 &z=0
  case product of
     'e':void=execute('cbar={'+product+'x:[-0.02,0.02],'$
                      +product+'y:[-0.01,0.01],'+product+'z:[-0.06,0.06]}')
     'b':void=execute('cbar={'+product+'z:[-0.1,0.1]}')
     'ue':
     'ui':void=execute('cbar={'+product+'x:[-0.12,0.12],'$
                      +product+'y:[-0.07,0.07],'+product+'z:[-0.06,0.06]}')
     'uo':void=execute('cbar={'+product+'x:[-0.03,0.03],'$
                      +product+'y:[-0.04,0.04],'+product+'z:[-0.02,0.02]}')
     'j':void=execute('cbar={'+product+'x:[-0.03,0.03],'$
                      +product+'y:[-0.03,0.03],'+product+'z:[-0.01,0.01]}')
  endcase
  
  return,cbar
end

PRO save_demo, print=print
;-----------------------------------------
;Parameter 
;-----------------------------------------
tlist=get_tlist()
product=['e','b','ue','ui','uo','j']
path='/Users/yanhualiu/Desktop/plots/'
dim=[0,2230,-60,60]
;dim=[1170,1380,-60,60] 
;-----------------------------------------
;Open and plot
;-----------------------------------------
for i=0,n_elements(tlist)-1 do begin
    opengda,tlist[i]              ; open .gda files
    step=tlist[i]
    for j=0,n_elements(product)-1 do begin   
       if keyword_set(print) then $
          PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_AAA_'+product[j]+'.ps'
       plot_multi_quantity,$
          [product[j]+'x',product[j]+'y',product[j]+'z'],tlist[i],$
          dim=dim,$
          print=keyword_set(print) ,cbar=get_cbar(product[j])
       xyouts,0.98,0.5,strupcase(product[j]),charsize=1.7,/normal,orientation=-90
       if keyword_set(print) then PS_END,/PDF,/delete_ps
       if not keyword_set(print) then stop
    endfor


;-----------------------------------------
;plot density
;-----------------------------------------

if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_AAA_density.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={nee:get_quantity('ne',step),ni:get_quantity('ni',step),no:get_quantity('no',step)},$
      dim=dim,$
      print=keyword_set(print),cbar={nee:[0,0.1],ni:[0,0.1],no:[0,0.1]}
   xyouts,0.98,0.5,'n',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop



;-----------------------------------------
;plot ExB drift
;-----------------------------------------

   btot=get_quantity('absB',step)
   ecrossbx=cross_field('e','b','x',step)/(btot)^2
   ecrossby=cross_field('e','b','y',step)/(btot)^2
   ecrossbz=cross_field('e','b','z',step)/(btot)^2
   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_BBB_ExB.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:ecrossbx,$
                      y:ecrossby,$
                      z:ecrossbz}, $
      /ay,dim=dim,$
      print=keyword_set(print) ,cbar={x:[-0.5,0.5],y:[-0.6,0.6],z:[-0.3,0.3]}
   xyouts,0.98,0.5,'Vexb',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop

;-----------------------------------------
;plot eperp
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_CCC_eperp.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_perp('e','x',step),$
                      y:velocity_perp('e','y',step),$
                      z:velocity_perp('e','z',step)}, $
      /ay,dim=dim,$
      print=keyword_set(print),cbar={x:[-0.5,0.5],y:[-0.6,0.6],z:[-0.3,0.3]};cbar={x:[-0.2,0.2],y:[-0.2,0.2],z:[-0.2,0.2]}
   xyouts,0.98,0.5,'e perp',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
   
;-----------------------------------------
;plot iperp
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_DDD_iperp.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_perp('i','x',step),$
                      y:velocity_perp('i','y',step),$
                      z:velocity_perp('i','z',step)}, $
      /ay,dim=dim,$
      cbar={x:[-0.5,0.5]/2.,y:[-0.6,0.6]/2.,z:[-0.3,0.3]/2.},print=keyword_set(print)
   xyouts,0.98,0.5,'i perp',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
   
;-----------------------------------------
;plot operp
;-----------------------------------------
   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_EEE_operp.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_perp('o','x',step),$
                      y:velocity_perp('o','y',step),$
                      z:velocity_perp('o','z',step)}, $
      /ay,dim=dim,$
      cbar={x:[-0.5,0.5]/4.,y:[-0.6,0.6]/4.,z:[-0.3,0.3]/4.},print=keyword_set(print)
   xyouts,0.98,0.5,'O perp',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
;-----------------------------------------
;plot e parallel
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_CCC_epara.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_par('e',step,xyz='x'), $
                      y:velocity_par('e',step,xyz='y'), $
                      z:velocity_par('e',step,xyz='z')},$
      /ay,dim=dim,$
      print=keyword_set(print) , cbar={x:[-0.09,0.09],y:[-0.03,0.03],z:[-0.03,0.03]}
   xyouts,0.98,0.5,'e para',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
   
;-----------------------------------------
;plot i parallel
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_DDD_ipara.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_par('i',step,xyz='x'), $
                      y:velocity_par('i',step,xyz='y'), $
                      z:velocity_par('i',step,xyz='z')},$
      /ay,dim=dim,$
      cbar={x:[-0.09,0.09]/2.,y:[-0.03,0.03]/2.,z:[-0.03,0.03]/2.},print=keyword_set(print)
   xyouts,0.98,0.5,'i para',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop

;-----------------------------------------
;plot o parallel
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_EEE_opara.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:velocity_par('o',step,xyz='x'), $
                      y:velocity_par('o',step,xyz='y'), $
                      z:velocity_par('o',step,xyz='z')},$
      /ay,dim=dim,$
      cbar={x:[-0.09,0.09]/2.,y:[-0.03,0.03]/2.,z:[-0.03,0.03]/2.},print=keyword_set(print)
   xyouts,0.98,0.5,'o para',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop

;-----------------------------------------
;plot E+VXB
;-----------------------------------------

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_FFF_eohm.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={eex:calc_er('e','x',step),$
                      eey:calc_er('e','y',step),$
                      eez:calc_er('e','z',step)} , $
      cbar={eex:[-0.1,0.1]/4,$
            eey:[-0.03,0.03]/4,eez:[-0.1,0.1]/4},$
      dim=dim,print=keyword_set(print)
   xyouts,0.98,0.5,'e ohm',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop


   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_FFF_iohm.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={eex:calc_er('i','x',step),$
                      eey:calc_er('i','y',step),$
                      eez:calc_er('i','z',step)} , $
      cbar={eex:[-0.1,0.1]/4.,$
            eey:[-0.03,0.03]/2.,eez:[-0.1,0.1]/2.},$
      dim=dim,print=keyword_set(print)
   xyouts,0.98,0.5,'i ohm',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop

   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_FFF_oohm.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={eex:calc_er('o','x',step),$
                      eey:calc_er('o','y',step),$
                      eez:calc_er('o','z',step)} , $
      cbar={eex:[-0.1,0.1]/5,$
            eey:[-0.03,0.03]/4,eez:[-0.1,0.1]/2},$
      dim=dim,print=keyword_set(print)
   xyouts,0.98,0.5,'o ohm',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop

;-----------------------------------------
;plot the current carrier
;-----------------------------------------

;next:
   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_GGG_je.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:-1.*get_quantity('ne',step)*get_quantity('uex',step),$
                      y:-1.*get_quantity('ne',step)*get_quantity('uey',step),$
                      z:-1.*get_quantity('ne',step)*get_quantity('uez',step)} , $
      dim=dim,print=keyword_set(print) ,$
      cbar={x:[-0.04,0.04],$
            y:[-0.04,0.04],z:[-0.007,0.007]}
   
   xyouts,0.98,0.5,'je',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
   
   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_GGG_ji.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:get_quantity('ni',step)*get_quantity('uix',step),$
                      y:get_quantity('ni',step)*get_quantity('uiy',step),$
                      z:get_quantity('ni',step)*get_quantity('uiz',step)} , $
      dim=dim,print=keyword_set(print) ,$
      cbar={x:[-0.007,0.007],$
            y:[-0.003,0.003],z:[-0.002,0.002]}
   
   xyouts,0.98,0.5,'ji',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop
   
   
   if keyword_set(print) then $
      PS_START,FILENAME=path+string(format='(i06)',tlist[i])+'_GGG_jo.ps'
   plot_multi_quantity,$
      [],step,$
      extra_quantity={x:get_quantity('no',step)*get_quantity('uox',step),$
                      y:get_quantity('no',step)*get_quantity('uoy',step),$
                      z:get_quantity('no',step)*get_quantity('uoz',step)} , $
      dim=dim,print=keyword_set(print) ,$
      cbar={x:[-0.007,0.007],$
            y:[-0.003,0.003],z:[-0.002,0.002]}
   
   xyouts,0.98,0.5,'jo',charsize=1.7,/normal,orientation=-90
   if keyword_set(print) then PS_END,/PDF,/delete_ps
   if not keyword_set(print) then stop


   close,/all
   free_lun,1
   spawn,'purge'
   spawn,'python process_pdf.py'
endfor

close,/All

free_lun, 1

stop
END
