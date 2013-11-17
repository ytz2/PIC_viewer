
;+
; NAME:
;       PLOT_PATTERN
;
; PURPOSE:
;       Plot flow line/fields
; CATEGORY:
;       Plot
;
; CALLING SEQUENCE:
;       plot_pattern,product,step
; Example:
;       PLOT_PATTERN,'e',step,dim=dim,smth=8,grid=[5,10]
;       PLOT_PATTERN,'i',step,dim=dim,smth=8,frt=0.002 ,length=0.05
; Keywords:
;       product: product.gda
;       step: time step
;       dim: if set return x or z array in given domain
;       smth: points to be smoothen
;       frt: if set, the frt of data will be shown (randomly)
;       length: if set, the new flow line length will replace the
;       default one
;       grid: grid=number draw grided flow pattern with number of grid
;             grid=[a,b] draw a number in x, b number in z
; Note:
;       the random and grid algorithm both have their
;       positive/negative side. For random one, it can catch the most
;       of flow pattern but give you a very sick plots. For grid one,
;       it can give you a nice plot but can only catch the main feature
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Oct 2012.


PRO PLOT_PATTERN,product,step,dim=dim,smth=smth,frt=frt,length=length,grid=grid

common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory


v={xmin:0.0,xmax:xmax,zmin:-1.*zcenter,zmax:zcenter,smoothing:15,contours:24}

if (n_elements(dim) ne 0) then begin
   v.xmin=dim[0]
   v.xmax=dim[1]
   v.zmin=dim[2]
   v.zmax=dim[3]
endif

if (n_elements(smth) ne 0) then v.smoothing=smth


if n_elements(frt) eq 0 then frt=1.

if n_elements(length) eq 0 then length=0.08


case product of 
   'e': p_arr=['uex','uez']
   'i': p_arr=['uix','uiz']
   'o': p_arr=['uox','uoz']
   'j': p_arr=['jx','jz']
endcase

vx=get_quantity(p_arr[0],step)
vz=get_quantity(p_arr[1],step)

imin=fix(v.xmin/xmax*nx)
imax=fix(v.xmax/xmax*nx)-1
lx = imax-imin +1 
jmin = fix((1.0+v.zmin/zcenter)*nz/2)
jmax = nz-1-fix((1.0-v.zmax/zcenter)*nz/2)
lz = jmax-jmin +1 

if n_elements(dim) ne 0 then begin
   vx = smooth(vx(imin:imax,jmin:jmax),v.smoothing,/nan)
   vz = smooth(vz(imin:imax,jmin:jmax),v.smoothing,/nan)
endif

if  n_elements(grid) eq 0 then begin

   xarr = ((v.xmax-v.xmin)/lx)*(findgen(lx)+0.5) + v.xmin
   zarr = v.zmin + ((v.zmax-v.zmin)/lz)*(findgen(lz)+0.5)
   
endif else begin
   if n_elements(grid) eq 2 then begin
      temp_nx=grid[0]
      temp_nz=grid[1]
   endif 
   
   if n_elements(grid) eq 1 then begin
      temp_nx=grid
      temp_nz=grid
   endif
  
   xarr=scale_vector(findgen(temp_nx),v.xmin,v.xmax)
   zarr=scale_vector(findgen(temp_nz),v.zmin,v.zmax)
   temp_vx=fltarr(temp_nx,temp_nz)
   temp_vz=fltarr(temp_nx,temp_nz)
   for i=0,temp_nx-1 do begin
      islice=fix((xarr[i]-v.xmin)/(v.xmax-v.xmin)*float(lx)-0.5)
      for j=0,temp_nz-1 do begin
         jslice=fix((zarr[j]-v.zmin)/(v.zmax-v.zmin)*float(lz)-0.5)
         temp_vx[i,j]=vx[islice,jslice]
         temp_vz[i,j]=vz[islice,jslice]
      endfor
   endfor
   
   vx=temp_vx
   vz=temp_vz
endelse

xmatrix=cmreplicate(xarr,n_elements(zarr))
zmatrix=transpose(cmreplicate(zarr,n_elements(xarr)))

PARTVELVEC, vx, vz,xmatrix,zmatrix, /over,frac=frt,length=length

end
   
