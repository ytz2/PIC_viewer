

;+
; NAME:
;      plot_cut_dist
;
; PURPOSE:
;       use display_dist.py to plot distributions along xcut/zcut
;
; CATEGORY:
;       Utitlity
;
;
; INPUTS:
;       xcut,zcut plot x=xcut(zcut) line dist 
;       xrange,zrange plot [xrange,zrange] cut
;       sav, save figures
;       default value is set at xcut=xmax/2,zrange=[-zmax/2,zmax/2]
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note:  Parameters must be given in sequence, or the logically
;repeated ones will be neglected

PRO PLOT_CUT_DIST,step,$
   xcut=xcut,zcut=zcut,$
   xrange=xrange,zrange=zrange,$
   sav=sav,nostop=nostop,path=path,mag=mag,subtract=subtract
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory


; set default box range
i0=31 & j0=31

dx=xmax/64.
dz=zmax/64.
limits=0.75

if n_elements(xcut) ne 0 then i0=floor(xcut/dx)
if n_elements(zcut) ne 0 then j0=floor((zcut+zmax/2.)/dz)
if n_elements(xrange) ne 0 then begin
   xrange=floor(xrange/dx)
   i0=xrange[0]+indgen(xrange[1]-xrange[0]+1)
endif
if n_elements(zrange) ne 0 then begin
   zrange=floor((zrange+zmax/2.)/dz)
   j0=zrange[0]+indgen(zrange[1]-zrange[0]+1)
endif
if n_elements(lim) ne 0 then limits=lim
if n_elements(specie) ne 0 then spe=specie

; Calc footprint 
xx=(i0+0.5)*dx
zz=(j0+0.5-32)*dz

; Now do plot

for ii=0,n_elements(i0)-1 do begin
   for jj=0, n_elements(j0)-1 do begin
      
      cmd='python display_distr.py '+' '+string(i0[ii])+' '+string(j0[jj])+' '+strtrim(string(step),2)
      plotsym,8,1.7,THICK=2.3
      oplot,[xx[ii]],[zz[jj]],psym=8
      if n_elements(xrange) ne 0 then $         
         xyouts,[xx[ii]],[zz[jj]+30],strtrim(string(i0[ii]),1),color=1,size=0.6
      if n_elements(zrange) ne 0 then $         
         xyouts,[xx[ii]+30],[zz[jj]],strtrim(string(j0[jj]),1),color=1,size=0.6
      print, [xx[ii]],[zz[jj]], 'is marked'
      print, 'correspond to:'
      print, i0[ii],j0[jj]
      if keyword_set(mag) then cmd=cmd+ ' '+ 'mag '
      if keyword_set(subtract) then cmd=cmd+ ' '+ 'subtract '
      if keyword_set(sav) then cmd=cmd+' '+'save'+' '+path
      print,cmd
      spawn,cmd
      ;VIEW_DIST,'H',i0[ii],j0[jj]
      ;VIEW_DIST,'O',i0[ii],j0[jj],/logs
      print, i0[ii],j0[jj]
      if (not keyword_set(sav)) and (not keyword_set(nostop)) then stop      
   endfor
endfor

print,xmax,zmax

END
