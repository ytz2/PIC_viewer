;+
; NAME:
;      PLOT_CONTOUR
;
; PURPOSE:
;      Plot a given quantity
;
; CATEGORY:
;       Plot
;
;
; INPUTS:
;       indata: data processed but keep the format as got by get_quantity.pro
;       product: quantity
;       step: time step
; Option Input:
;       dim: domain [x0,x1,y0,y1]
;       bar_low: color bar lower limit
;       bar_up: color bar upper limit (set with bar_low)
;       dat: return the data at give dim
;       ay:  if set, overplot ay
;       print: /print to output ps file
;       multi: /multi to make multiplot enabled
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note: it will not check if the given coordinate is out of bound
;       Edited by: Yanhua Liu Nov 2012
;       Remove the over_contour keyword and replace with ay keyword

PRO PLOT_CONTOUR $
   ,product $  
   ,step $
   ,indata=indata $
   ,dim=dim $
   ,bar_low=bar_low $
   ,bar_up=bar_up $
   ,dat=dat $
   ,ay=ay $ 
   ,print=print $
   ,multi=multi $
   ,zcut=zcut
common choice, plotme
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
common colortable,rgb,usecolor,red,blue,green,range1,range2,r1,r2,tmax,tmin
common controlplot,v

if n_elements(indata) eq 0 then begin
   fulldata=get_quantity(product,step)
endif else begin
   fulldata=indata
endelse

csize=1.5
if keyword_set(print) then csize=1.

v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:1,contours:14}

if (n_elements(dim) ne 0) then begin
    v.xmin=dim[0]
    v.xmax=dim[1]
    v.zmin=dim[2]
    v.zmax=dim[3]
endif



xoff = 0.09
yoff = 0.11
xpic = 0.90
ypic = 0.92
dx1=0.012
dx2=0.04

;copy data for plotting, it is a bad ssidea,but we need to do that
temp=fulldata
;  Now shift data the required amount in y direction


; Select region of 2d-data to plot - This allows me to create contours just within the specified
; region and ignore the rest of the data

imin=fix(v.xmin/xmax*nx)
imax=fix(v.xmax/xmax*nx)-1
lx = imax-imin +1 
jmin = fix((1.0+v.zmin/zcenter)*nz/2)
jmax = nz-1-fix((1.0-v.zmax/zcenter)*nz/2)
lz = jmax-jmin +1 

if n_elements(dim) ne 0 then $
   temp = fulldata(imin:imax,jmin:jmax)
if arg_present(dat) then $
   dat=temp

; Output info about data

;print,'Maximum Value=',max(abs(temp))

; Smooth the temp

temp = smooth(temp,v.smoothing,/nan)

; Create x and y coordinates

xarr = ((v.xmax-v.xmin)/lx)*(findgen(lx)+0.5) + v.xmin
zarr = v.zmin + ((v.zmax-v.zmin)/lz)*(findgen(lz)+0.5)


r1=min(temp)
r2=max(temp)
dr = (r2-r1)*0.5
r1=r1-dr/2
r2=r2+dr/2

if ( n_elements(bar_low) ne 0 and n_elements(bar_up) ne 0) then begin
    r1=bar_low
    r2=bar_up
endif


!x.style=1
!y.style=1
!p.color =1
!p.background=0
!x.title="x/d!le!n"
!y.title="z/d!le!n"



if not keyword_set(print) and !p.multi[0] eq 0 then $
   window,!D.WINDOW +1,xsize=1200,ysize=800




name=product+' step='+strcompress(string(step))

;!p.position=[xoff,yoff,xpic,ypic] 
position=[xoff,yoff,xpic,ypic] 
if keyword_set(print) and not keyword_set(multi) then $
   postion=[xoff+0.05,yoff,xpic-0.08,ypic]

if keyword_set(multi) then begin
   Plot, Findgen(11), Color=!P.Background,/noerase
   x1 = !X.Region[0] + 0.05
   x2 = !X.Region[1] - 0.12
   y1 = !Y.Region[0] + 0.02
   y2 = !Y.Region[1] - 0.02
   position=[x1,y1,x2,y2]
endif

shade_surf, temp, xarr, zarr, ax=90,az=0,shades=bytscl(temp,max=r2,min=r1),zstyle=4,charsize=csize,pixels=1000,position=position
if not keyword_set(multi) then $
   xyouts,v.xmin+(v.xmax-v.xmin)/3.5,(v.zmax)*1.02,name,charsize=csize+0.5
!x.title=""
!y.title=""

name=''
if keyword_set(multi) then name=product&fit=1

;[xpic+dx1,yoff,xpic+dx2,ypic]

if keyword_set(multi) then xpic=0.85

cgcolorbar, Position = [xpic+dx1/2,yoff,xpic+dx2/2,ypic], /Vertical, $
          Range=[r1,r2], Format='(f8.2)', /right, $
          Bottom=5, ncolors=251, Divisions=6, font=9, charsize=csize,fit=fit,title=name,xticks=6

if keyword_set(ay) then begin
   temp2=get_quantity('ay',step)
   if n_elements(dim) ne 0 then $
      temp2 = temp2(imin:imax,jmin:jmax)
   temp2 = smooth(temp2,v.smoothing,/nan)
   tmax=max(temp2)
   tmin=min(temp2)
   dr = (tmax-tmin)*0.20
   tmin=tmin-dr/2
   tmax=tmax+dr/2
   tstep=(tmax-tmin)/v.contours
   clevels=indgen(v.contours)*tstep + tmin       
   contour,temp2,xarr,zarr,levels=clevels,/overplot,color=250

endif

if n_elements(zcut) ne 0 then oplot,[0,2500],[0,0],color=0



END

