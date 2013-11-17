;+
; NAME:
;      GET_TLIST
;
; PURPOSE:
;       get the over all time slices
; EXPLANATION:
;       return a int list of time steps
;
; CATEGORY:
;       Utitlity
;
; CALLING SEQUENCE:
;       res=get_list()
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), May 2012.

FUNCTION GET_TLIST,h=h
;directory='/cluster11/yhliu/oxygen-run1/data'
dd='/Volumes/Liu/oxygen-run1/data'
if keyword_set(h) then dd='/Volumes/Liu/proton-run/data'
CD,current=old
;CD,directory
CD,dd
res=file_search('T.*')
CD,old

a=lonarr(n_elements(res))
for i=0,n_elements(res)-1 do begin
   a[i]=long(strmid(res[i],2,20))
   ;stop
endfor
a=a[sort(a)]
print, "Available Time Slices:"
print,a
return,a
END
