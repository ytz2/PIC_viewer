

PRO compare, lower,middle, INTERP = interp, SSCALE=sscale, E_CONTOUR=ec, $
	E_SURFACE=es,bar_low=bar_low,bar_up=bar_up
; Show an image three ways...
;+
; NAME:
;	compare
;
; PURPOSE:
;	Show a 2D array three ways in a display that combines SURFACE, 
;	CONTOUR, and an image (color/gray scale pixels).
;
; CATEGORY:
;	Display, graphics.
;
; CALLING SEQUENCE:
;	SHOW3, Image [, INTERP = Interp, SSCALE = Sscale]
;
; INPUTS:
;	Image:	The 2-dimensional array to display.
;
; OPTIONAL INPUTS:
;	X = a vector containing the X values of each column of Image.
;		If omitted, columns have X values 0, 1, ..., Ncolumns-1.
;	Y = a vector containing the Y values of each row of Image.
;		If omitted, columns have Y values 0, 1, ..., Nrows-1.
; KEYWORD PARAMETERS:
;	INTERP:	Set this keyword to use bilinear interpolation on the pixel 
;		display.  This technique is slightly slower, but for small 
;		images, it makes a better display.
;
;	SSCALE:	Reduction scale for surface. The default is 1.  If this
;		keyword is set to a value other than 1, the array size 
;		is reduced by this factor for the surface display.  That is, 
;		the number of points used to draw the wire-mesh surface is
;		reduced.  If the array dimensions are not an integral multiple
;		of SSCALE, the image is reduced to the next smaller multiple.
;	E_CONTOUR: a structure containing additional keyword parameters
;		that are passed to the CONTOUR procedure.  See the example
;		below.
;	E_SURFACE: a structure containing additional keyword parameters
;		that are passed to the SURFACE procedure.  See the example
;		below.
;
; OUTPUTS:
;	No explicit outputs.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	A new plot is generated.
;
; RESTRICTIONS:
;	The display gets too "busy" when displaying larger (say 50 by 50),
;	images, especially if they are noisy.  It can be helpful to use
;	the SSCALE keyword or the SMOOTH and/or REBIN functions to smooth the 
;	surface plot.
;
;	You might want to modify the calls to CONTOUR and SURFACE slightly
;	to customize the display to your tastes, i.e., with different colors,
;	skirts, linestyles, contour levels, etc.
;
; PROCEDURE:
;	First, do a SURFACE with no data to establish the 3D to 2D scaling.
;	Then convert the coordinates of the corner pixels of the array to
;	2D.  Use POLYWARP to get the warping polynomial to warp the
;	2D image into the area underneath the SURFACE plot.  Output the image,
;	output the surface (with data) and then output the contour plot at
;	the top (z=1).
;

; MODIFICATION HISTORY:
;	Yanhua Liu 2013
;-

common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
on_error,2              ;Return to caller if an error occurs

v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:1,contours:18}

if (n_elements(dim) ne 0) then begin
   v.xmin=dim[0]
   v.xmax=dim[1]
   v.zmin=dim[2]
   v.zmax=dim[3]
endif

imin=fix(v.xmin/xmax*nx)
imax=fix(v.xmax/xmax*nx)-1
lx = imax-imin +1 
jmin = fix((1.0+v.zmin/zcenter)*nz/2)
jmax = nz-1-fix((1.0-v.zmax/zcenter)*nz/2)
lz = jmax-jmin +1 

xarr = ((v.xmax-v.xmin)/lx)*(findgen(lx)+0.5) + v.xmin
zarr = v.zmin + ((v.zmax-v.zmin)/lz)*(findgen(lz)+0.5)


if n_elements(sscale) eq 0 then sscale = 1 ;Default scale
sscale = fix(sscale)		;To Integer


if ((nx mod sscale) ne 0) or ((nz mod sscale) ne 0) then begin
	nnx = (nx/sscale) * sscale ;To multiple
	nny = (nz/sscale) * sscale
	lower = lower[0:nnx-1, 0:nny-1]
        middle = middle[0:nnx-1, 0:nny-1]
	xx = xarr[0:nnx-1]
	yy = yarr[0:nny-1]
endif else begin
	xx = xarr
	yy = zarr
        nnx=nx
        nny=nz
endelse

		;Set up scaling
if n_elements(bar_low) ne 0 then $
   SURFACE, lower, xx, yy, /SAVE,/NODATA,XST=1,YST=1,ZAXIS=1, _EXTRA=es,max_val=bar_up,min_val=bar_low

SURFACE, lower, xx, yy, /SAVE,/NODATA,XST=1,YST=1,ZAXIS=1, _EXTRA=es
empty			;Don't make 'em wait watching an empty screen.

xorig = [xarr[0],xarr[nnx-1],xarr[0],xarr[nnx-1]]	;4 corners X locns in image
yorig = [zarr[0],zarr[0],zarr[nny-1],zarr[nny-1]]	;4 corners Y locns

xc = xorig * !x.s[1] + !x.s[0]	;Normalized X coord
yc = yorig * !y.s[1] + !y.s[0]	;Normalized Y
			;To Homogeneous coords,  and transform
p = [[xc],[yc],[fltarr(4)],[replicate(1,4)]] # !P.T 
u = p[*,0]/p[*,3] * !d.x_vsize	;Scale U coordinates to device
v = p[*,1]/p[*,3] * !d.y_vsize	;and V
;
;	Now, the 4 corners of the place for the image are in u and v
;
u0 = min(u) & v0 = min(v)		;Lower left corner of screen box
su = max(u)- u0+1 & sv = max(v) - v0+1	;Size of new image
if (!d.flags and 1) eq 1 then begin	;Scalable pixels (PostScript)?
	fact = 50		;Yes, shrink it
	miss = 255		;Missing values are white
	c_color=[0,0]		;Contour in only one color, black
 endif else begin
	fact = 1 		;one pixel/output coordinate
	miss = 0		;missing is black
	c_color=[150,200,250]
 endelse

if (!d.flags and 512) ne 0 then $  ;White background?
	miss = 255 else miss = 0
;
	;Get polynomial coeff for warp
if !d.n_colors gt 2 then top = !d.n_colors -1 else top = 255

POLYWARP, [0,nnx-1,0,nnx-1],[0,0,nny-1,nny-1], (u-u0)/fact, (v-v0)/fact, 1, kx, ky

A = POLY_2D(BYTSCL(lower, top=top), kx, ky, KEYWORD_SET(interp), $
		su/fact,sv/fact, missing = miss) ;Warp it
TV, a, u0, v0, xsize = su, ysize = sv, order=0




SURFACE, REBIN(middle, nnx/sscale, nny/sscale),$
	REBIN(xx, nnx/sscale), REBIN(yy, nny/sscale), _EXTRA=es, $
	/SAVE, /NOERASE, XST=1, YST=1, BOT=128 ;Show the surface
                        ; Redraw front-right Z axis.


end
