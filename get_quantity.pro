;+
; NAME:
;       GET_QUANTITY
;
; PURPOSE:
;       return a 2d array of given quantity at give time step
;
; CALLING SEQUENCE:
;       result=get_quantity(quantity,time)
;
; INPUTS:
;       quantity: quantity.gda
;       time: time step
;       dim: [x0,x1,y0,y1]
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Oct 2012.





function get_quantity,quantity,time,dim=dim,perturbed =perturbed,verbose=verbose

; get simulation quantity
; Input: quantity listed in plotme and timestep, if /perturbed
; indicated, will subtract the initial condition

common choice, plotme
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory


index=(where(plotme eq (quantity+'_'+strtrim(string(time),1))))[0]
; Read needed data for contour plot

if keyword_set(verbose) then begin
   print
   print,'----------get quantity----------'
   print,'--------------------------------'
   print,"Output Record=",plotme(index)
   print,"   Time Index=",time
endif

struct = {data:fltarr(nx,nz)}
field = assoc(index,struct)
struct = field[0]


fulldata=struct.data


;  Substract initial equilibrium is desired

if ( keyword_set(perturbed) and time gt 0 ) then begin

   print," *** Subtract initial value, to give perturbation ***"
   time_string = '0'
   openr, unit,directory+'/T.'+time_string+'/'+plotme(quantity)+'_'+time_string+'.gda',/get_lun
    field = assoc(unit,struct)
    struct = field[0]
    close, unit
    free_lun,unit

    fulldata = fulldata - struct.data

endif

; Select region of 2d-data to plot - This allows me to create contours just within the specified
; region and ignore the rest of the data

if ( n_elements(dim) ne 0) then begin 

   imin=fix(dim[0]/xmax*nx)
   imax=fix(dim[1]/xmax*nx)-1
   lx = imax-imin +1 
   jmin = fix((1.0+dim[2]/zcenter)*nz/2)
   jmax = nz-1-fix((1.0-dim[3]/zcenter)*nz/2)
   lz = jmax-jmin +1 
   fulldata = fulldata(imin:imax,jmin:jmax)
endif

return ,fulldata

END
