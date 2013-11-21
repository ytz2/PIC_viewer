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
;       product: quantity
;       step: time step
; Option Input:
;       dim: domain [x0,x1,y0,y1]
;       bar_low: color bar lower limit
;       bar_up: color bar upper limit (set with bar_low)
;       dat: return the data at give dim
;       over_contour: quantity to make contour plot
;       xcut: mark one cut at x=xcut
;       zcut: mark one cut at z=zcut
;       print: /print to output ps file
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.
;Note: it will not check if the given coordinate is out of bound


PRO PLOT_CONTOUR $
   ,product $
   ,step $
   ,dim=dim $
   ,bar_low=bar_low $
   ,bar_up=bar_up $
   ,dat=dat $
   ,over_contour=over_contour $
   ,over_log=over_log $
   ,xcut=xcut $
   ,zcut=zcut $
   ,print=print
  



common choice, plotme
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
common colortable,rgb,usecolor,red,blue,green,range1,range2,r1,r2,tmax,tmin
common controlplot,v

fulldata=get_quantity(product,step)


v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:1,contours:24}

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

print,'Maximum Value=',max(abs(temp))

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
!x.title="x"
!y.title="z"

!p.position=[xoff,yoff,xpic,ypic] 

if not keyword_set(print) then $
   window,!D.WINDOW +1,xsize=1200,ysize=800

shade_surf, temp, xarr, zarr, ax=90,az=0,shades=bytscl(temp,max=r2,min=r1),zstyle=4,charsize=1.5,pixels=1000
 xyouts,v.xmin+(v.xmax-v.xmin)/3.5,(v.zmax)*1.02,product+'  step='+strcompress(string(step)),charsize=2.0

!x.title=""
!y.title=""

colorbar, Position = [xpic+dx1,yoff,xpic+dx2,ypic], /Vertical, $
          Range=[r1,r2], Format='(f6.2)', /Right, $
          Bottom=5, ncolors=251, Divisions=6, font=9, charsize=1.5

if n_elements(over_contour) ne 0 then begin
   temp2=get_quantity(over_contour,step)
   if keyword_set(over_log) then temp2=alog10(temp2)
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
   if keyword_set(over_log) then clevels=scale_vector(findgen(12),tmin+1,tmax)
   contour,temp2,xarr,zarr,levels=clevels,/overplot,color=250
endif

if n_elements(xcut) ne 0 then $
   oplot,[xcut,xcut],[-1e4,1e4]

if n_elements(zcut) ne 0 then $
   oplot,[-1e4,1e4], [zcut,zcut]


END

