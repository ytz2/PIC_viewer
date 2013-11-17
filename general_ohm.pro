
; INPUTS:
;       step: time step
;       component: 'x','y','z'
;       specie: 'H','O'
;       xcut: cut at x=xcut de location
;       zcut: cut at z=zcut de location conflict with xcut
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note: it will not check if the given coordinate is out of bound


PRO GENERAL_OHM, STEP,component,SPECIE,xcut=xcut,zcut=zcut,xrange=xrange,yrange=yrange,smth=smth
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

if not keyword_set(smth) then smth=10

if keyword_set(xcut) then begin
   
   efield=map_data(data=get_quantity('e'+component,step),xcut=xcut)
   uxb=map_data(data=-1.*cross_field('u'+specie,'b',component,step),xcut=xcut)
   hall=map_data(data=cross_field('j','b',component,step)/get_quantity('ne',step),xcut=xcut)
   divp= DIV_P(STEP,COMPONENT,xcut=xcut)
   arr=linespace(/z)
   xtitle='z'
   ytitle='E'+component
endif

if keyword_set(zcut) then begin
   
   efield=map_data(data=get_quantity('e'+component,step),zcut=zcut)
   uxb=map_data(data=-1.*cross_field('u'+specie,'b',component,step),zcut=zcut)
   hall=map_data(data=cross_field('j','b',component,step)/get_quantity('ne',step),zcut=zcut)
   divp= DIV_P(STEP,COMPONENT,zcut=zcut)
   arr=linespace(/x)
   xtitle='x'
   ytitle='E'+component
endif

thm_init,/reset
window,!D.WINDOW +1,xsize=1200,ysize=800

plot,arr,smooth(efield,smth),xrange=xrange,yrange=yrange,xtitle=xtitle,ytitle=ytitle
oplot,arr,smooth(uxb,smth),color=1
oplot,arr,smooth(hall,smth),color=2
oplot,arr,smooth(divp,smth),color=3
oplot,arr,smooth(uxb+hall+divp,smth),color=4


LEGEND,[ytitle,'U'+SPECIE+'xB','Hall','div(P)','sum'],textcolors=[0,1,2,3,4],/right,/top,charsize=1.3 
reload_ct

stop
END



