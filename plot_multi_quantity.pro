;+
; NAME:
;      PLOT_Multi_quantity
;
; PURPOSE:
;      Plot mult quantity in a window
; CATEGORY:
;       Plot
;
;
; INPUTS:
;      quantity: string array
;      dim: domain size
;      step: time step
;      extra_quantity: structure with string name and data defined by
;      user
;      cbar: structure  {var_name:[bar_low,bar_up]}
;      ay:   ay is overploted if set
;      print: if keyword set print the printing module start
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note: it will not check if the given coordinate is out of bound
;       Edited by Yanhua, Nov 2012
;       add ay keyword

FUNCTION MATCH_ZLIM,quantity,cbar
  bar_names=tag_names(cbar)
  ind=where(bar_names  eq strupcase(quantity))
  if ind eq -1 then return, 0
  return, cbar.(ind)
END

PRO DO_CUT,data,zcut,dim,ytlt,bar_lim,step
   Plot, Findgen(11), Color=!P.Background,/noerase
   x1 = !X.Region[0] + 0.05
   x2 = !X.Region[1] - 0.12
   y1 = !Y.Region[0] + 0.02
   y2 = !Y.Region[1] - 0.02
   position=[x1,y1,x2,y2]
   xarr=linespace(/x)
   ydat=smooth(map_data(data=data,zcut=zcut),10)
   plot,xarr,ydat,xrange=dim[0:1],yrange=bar_lim,color=1,position=position,xtitle='x',ytitle=ytlt,charsize=1.5
   oplot,[0,2500],[0,0],linestyle=1
   print,ytlt
   if ytlt eq 'BY' then begin
      loadct2,33
      bx=smooth(map_data(data=get_quantity('bx',step),zcut=zcut),10)/0.5
      bz=smooth(map_data(data=get_quantity('bz',step),zcut=zcut),10)/0.5
      oplot,xarr,bx,color=20
      oplot,xarr,bz,color=1
      reload_ct
   endif
END


PRO PLOT_MULTI_QUANTITY, $
   QUANTITY,STEP,DIM=DIM,$
   extra_quantity=extra_quantity,cbar=cbar,ay=ay,print=print,zcut=zcut,pattern=pattern
  
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

ymargin=!y.margin
xmargin=!x.margin
!y.margin=[4,6]
!x.margin=[12,3]
v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:1,contours:24}
if n_elements(dim) eq 0 then $
   dim=[v.xmin,v.xmax,v.zmin,v.zmax]

in_quantity=n_elements(quantity)
user_quantity=0
if n_elements(extra_quantity) ne 0 then $
   user_quantity=n_elements(tag_names(extra_quantity))

!p.multi=[0,1,user_quantity+in_quantity]

if n_elements(zcut) ne 0 then !p.multi=[0,1,2*(user_quantity+in_quantity)]

over_pattern=0
if n_elements(pattern) ne 0 and n_elements(pattern) eq user_quantity+in_quantity then over_pattern=1


if n_elements(cbar) eq 0 then cbar={anyway:0}
for i=0,in_quantity-1 do begin
   bar_lim=match_zlim(quantity[i],cbar)
   plotay=0
   if keyword_set(ay) then $
      if STRMATCH(ay, quantity[i], /FOLD_CASE) EQ 1 then plotay=1
   if n_elements(bar_lim) eq 1 then $
      plot_contour,quantity[i],step,dim=dim,$
                   /multi,ay=plotay,print=keyword_set(print),zcut=zcut
   if n_elements(bar_lim) eq 2 then $
      plot_contour,quantity[i],step,dim=dim,$
                   /multi,bar_low=bar_lim[0],bar_up=bar_lim[1],$
                   ay=plotay,print=keyword_set(print),zcut=zcut

   if n_elements(zcut) then begin
      DO_CUT,get_quantity(quantity[i],step),zcut,dim,quantity[i]
   endif
   
   if over_pattern eq 1 then begin 
      if pattern[i] eq 'e' then length=0.03
      if pattern[i] eq 'i' or pattern[i] eq 'o' then length=0.03
      PLOT_PATTERN,pattern[i],step,dim=dim,smth=8,grid=[30,30],length=length
   endif
   
endfor
for j=0,user_quantity-1 do begin
   bar_lim=match_zlim((tag_names(extra_quantity))[j],cbar)
   plotay=0
   if keyword_set(ay) then $
      if  STRMATCH(ay, (tag_names(extra_quantity))[j], /FOLD_CASE) EQ 1 then plotay=1
   if n_elements(bar_lim) eq 1 then $
      plot_contour,(tag_names(extra_quantity))[j], step, dim=dim, $
                   indata=extra_quantity.(j),$
                   /multi,ay=plotay,print=keyword_set(print),zcut=zcut
   if n_elements(bar_lim) eq 2 then $
       plot_contour,(tag_names(extra_quantity))[j], step, dim=dim, $
                   indata=extra_quantity.(j),/multi,$
                    bar_low=bar_lim[0],bar_up=bar_lim[1],$
                    ay=plotay,print=keyword_set(print),zcut=zcut
   if n_elements(zcut) then begin
      DO_CUT,extra_quantity.(j),zcut,dim,(tag_names(extra_quantity))[j]
   endif

   if over_pattern eq 1 then begin 
      if pattern[in_quantity+j] eq 'e' then length=0.03
      if pattern[in_quantity+j] eq 'i' or pattern[in_quantity+j] eq 'o' then length=0.03
      PLOT_PATTERN,pattern[in_quantity+j],step,dim=dim,smth=8,grid=[30,30],length=length
   endif

endfor
!y.margin=ymargin
!x.margin=xmargin
!p.multi=0
END
