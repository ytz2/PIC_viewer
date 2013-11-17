;+
; NAME:
;      OPENGDA
;
; PURPOSE:
;       Open all the simulation files in give time step and store
;       units in common blocks
; EXPLANATION:
;       This procedure can only be used once, to reuse, add close,/all
;
; CATEGORY:
;       Utitlity
;
; CALLING SEQUENCE:
;       opengda,time_slice_at,/notv
;
; INPUTS:
;       time_slice_at: the time step, which corresponds to xxx_time_slice_at.gda
;
;
; OPTIONAL INPUT KEYWORD PARAMETERS:
;
;       notv: do not load the color table
;
; SIDE EFFECTS:
;       can only open one time step at a time
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.


PRO OPENGDA,time_slice_at,notv=notv,proton=proton,rerun=rerun

common choice, plotme
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
common colortable,rgb,usecolor,red,blue,green,range1,range2,r1,r2,tmax,tmin

;directory='/net/nfs/calypso/cluster10/yhliu/oxygen-run1/data'
;directory='/cluster11/yhliu/oxygen-run1/data'

;directory='/Volumes/Liu/oxygen-run1-rerun'
;directory='/run/media/yanhua/c6a05398-bff9-3da8-843a-3b8feca9274a/oxygen-run1/data'
;directory='/run/media/yanhua/Yanhua/oxygen-run1/data'
; Read in my color table

;infopath='/run/media/yanhua/c6a05398-bff9-3da8-843a-3b8feca9274a/oxygen-run1/data'

if keyword_set(rerun) then begin
   directory='/Volumes/Liu/oxygen-run1-rerun'
   infopath='/Volumes/Liu/oxygen-run1/data'
endif else if keyword_set(proton) then begin
   directory='/Volumes/Liu/proton-run/data'
   infopath='/Volumes/Liu/proton-run'
endif else begin
   directory='/Volumes/Liu/oxygen-run1/data'
   infopath='/Volumes/Liu/oxygen-run1/data'
endelse



if not keyword_set(notv) then begin
   nc=256
   rgb=fltarr(3,nc)
   usecolor=fltarr(3,nc)
   red=fltarr(nc)
   blue=fltarr(nc)
   green=fltarr(nc)
   CD,C=C
   openr, unit, C+'/Color_Tables/c5.tbl', /get_lun
;openr, unit, '~/Color_Tables/color.tbl', /get_lun
   readf, unit, rgb
   close, unit
   free_lun, unit
   red=rgb(0,*)
   green=rgb(1,*)
   blue=rgb(2,*)
   tvlct,red,green,blue
   ;tvlct,blue,green,red
endif
; Declare two integers (long - 32 bit)


device, decomposed = 0
device, retain = 2
nx=0L
ny=0L
nz=0L
numq=0L

if keyword_set(proton) then begin
   nx=7168
   nz=3168
   xmax=2236.068
   zmax=2236.068
   little=1
   goto, next
endif
; open binary file for problem description 

if ( file_test(infopath+'/info') eq 1 ) then begin
    print," *** Found Data Information File *** "
endif else begin
    print," *** Error - File info is missing ***"
endelse


;  First Try little endian then switch to big endian if this fails

little = 0
on_ioerror, switch_endian
openr,unit,infopath+'/info',/f77_unformatted, /get_lun,/swap_if_big_endian
readu,unit,nx,ny,nz
little=1
switch_endian: if (not little) then begin
    print, " ** Little endian failed --> Switch to big endian"
    close,unit
    free_lun,unit
    openr,unit,infopath+'/info',/f77_unformatted, /get_lun,/swap_if_little_endian
    readu,unit,nx,ny,nz
endif

; Read the problem desciption

;on_ioerror, halt_error1
readu,unit,xmax,ymax,zmax
close,unit
free_lun, unit

next:
; Find the names of data files in the data directory

datafiles = file_search(directory+'/T.'+strtrim(string(time_slice_at),1)+'/*.gda',count=numq) 

; Now open each file and save the basename to identify later

print," Number of files=",numq
plotme = strarr(numq+1)  
instring='     '
plotme(0)='None'
for i=1,numq do begin
    if (not little) then openr,i,datafiles(i-1) else openr,i,datafiles(i-1),/swap_if_big_endian
    plotme(i) = file_basename(datafiles(i-1),'.gda')
    print,"i=",i," --> ",plotme(i)
endfor

; Close the input file

close,unit
free_lun, unit

; Define twci

;twci = toutput/mime
kxmax=!pi/xmax*nx
kzmax=!pi/zmax*nz

; Define z0 

zcenter=zmax/2.

; Echo information

print,'nx=',nx,' nz=',nz
print,'xmax=',xmax,' zmax=',zmax



; Determine number of time slices

tlist=file_search(directory+'/T.*',count=tslices)
print,"Time Slices",tslices
if (tslices lt 1) then tslices=1
tindices = LONARR(tslices)

for i=0,tslices-1 do begin
    pos = STRPOS(tlist(i),'T.',/REVERSE_SEARCH)    
    tindices(i) = LONG(STRMID(tlist(i),pos+2))
endfor

tindices = tindices(SORT(tindices))

print, 'Pixels: [nx,nz]:',nx,nz

END
