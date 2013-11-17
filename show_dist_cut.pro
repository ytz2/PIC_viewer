
PRO show_cut,dist,vx=vx,vy=vy,vz=vz,sav=sav,tlt=tlt
  if keyword_set(vx) and not keyword_set(vy) and not keyword_set(vz) then begin
     xx=vx
     title='f(vx)'
     xtitle='vx'
     ytitle='f(vx)'
     yy=total(total(dist,3),2)
  endif

  if not keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then begin
     xx=vy
     title='f(vy)'
     xtitle='vy'
     ytitle='f(vy) counts'
     yy=total(total(dist,3),1)
  endif

  if not keyword_set(vx) and not keyword_set(vy) and keyword_set(vz) then begin
     xx=vz
     title='f(vz)'
     xtitle='vz'
     ytitle='f(vz) counts'
     yy=total(total(dist,2),1)
  endif
  if not keyword_set(sav) then $
     window,!d.window+1,xsize=600,ysize=400 ,title=title
  
  if not keyword_set(tlt) then $
     plot,xx,yy,psym=-1,xtitle=xtitle,ytitle=ytitle,/ylog,yrange=[1e0,max(yy,/nan)]
  if keyword_set(tlt) then $
     plot,xx,yy,psym=-1,xtitle=xtitle,ytitle=ytitle,/ylog,yrange=[1e0,max(yy,/nan)],title=tlt
end


PRO show_dist_cut,specie,i0,j0,tindex=tindex,sav=sav

if not keyword_set(tindex) then $
   tindex = 146240

;path='/net/nfs/pandora//cluster11/yhliu/oxygen-run1/distributions/data/'
path='/Volumes/Liu/oxygen-run1/distributions/data/'
fln=specie+'particle.'+strtrim(string(tindex),1)+'.dist.'+strtrim(string(i0),1)+'.0.'+strtrim(string(j0),1)+'.bin'

nv=lonarr(3)
vmax=dblarr(3)

openr,unit,path+fln,/get_lun
readu,unit,vmax
readu,unit,nv
dist=dblarr(nv[0],nv[1],nv[2])
readu,unit,dist
close,unit
free_lun, unit

vx = -vmax[0] + 2*vmax[0]/(nv[0]-1)*findgen(nv[0]);
vy = -vmax[1] + 2*vmax[1]/(nv[1]-1)*findgen(nv[1]);
vz = -vmax[2] + 2*vmax[2]/(nv[2]-1)*findgen(nv[2]);

if not keyword_set(sav) then begin
   if !d.window ne -1 then begin
      for i=0,!d.window do begin
         wdelete,i
      endfor
   endif
endif
;!p.multi=[0,2,2]
if keyword_set(sav) then begin 
   ps_start,specie+'_i'+strtrim(string(i0),1)+'_j'+strtrim(string(j0),1)+'.ps'
   !p.multi=[0,2,2]
endif
show_cut,dist,vx=vx,sav=keyword_set(sav),tlt='i='+strtrim(string(i0),1)+',j='+strtrim(string(j0),1)
show_cut,dist,vy=vy,sav=keyword_set(sav)
show_cut,dist,vz=vz,sav=keyword_set(sav)
if keyword_set(sav) then ps_end,/png,/delete_ps
END

PRO LOOP_SHOW_CUT
  for i=0,63 do begin
     show_dist_cut,'H',i,31,/sav
     show_dist_cut,'e',i,31,/sav
     show_dist_cut,'O',i,31,/sav
     
  endfor
END
