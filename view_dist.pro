

PRO show_dist,dist,vx=vx,vy=vy,vz=vz,logs=logs,angle=angle,dist2d=dist2d


if keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then begin
   if not keyword_set(angle) then $
      dist2D=total(dist,3)
   xx=vx
   yy=vy
   title='vx-vy'
   xtitle='vx'
   ytitle='vy'
endif

if keyword_set(vx) and not keyword_set(vy) and keyword_set(vz) then begin
   if not keyword_set(angle) then $
      dist2D=total(dist,2)
   xx=vx
   yy=vz
   title='vx-vz'
   xtitle='vx'
   ytitle='vz'

endif

if not keyword_set(vx) and keyword_set(vy) and keyword_set(vz) then begin
   if not keyword_set(angle) then $
      dist2D=total(dist,1)
   xx=vy
   yy=vz
   title='vy-vz'
   xtitle='vy'
   ytitle='vz'
endif

if  keyword_set(angle) then begin
   dist2d=dblarr(n_elements(xx),n_elements(yy))
   for i=0,n_elements(xx)-1 do begin
      for j=0,n_elements(yy)-1 do begin
         delta=((i-49.5)^2.+(j-49.5)^2.)^0.5*tan(!pi/180.*angle)
         the_start=long(49.5-delta)
         the_end=long(49.5+delta)+1
         if keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then $
            dist2d[i,j]=total(dist[i,j,the_start:the_end],/nan)
         if keyword_set(vx) and not keyword_set(vy) and keyword_set(vz) then $
            dist2d[i,j]=total(dist[i,the_start:the_end,j],/nan)
         if not keyword_set(vx) and keyword_set(vy) and keyword_set(vz) then $
            dist2d[i,j]=total(dist[the_start:the_end,i,j],/nan)
      endfor
   endfor
endif

;stop
nlevels=12
ind=where(dist2d lt 1)
dist2d[ind]=!values.f_nan


range=minmax(dist2d,/nan)

if keyword_set(logs) then begin 
   levels=scale_vector(findgen(nlevels),alog10(round(range[0])),alog10(round(range[1])))
   dist2d=alog10(dist2d)
endif

if not keyword_set(logs) then $
   levels=scale_vector(findgen(nlevels),min(dist2d,/nan),max(dist2d,/nan))


window,!d.window+1,xsize=600,ysize=400 ,title=title

cgLoadCT, 33, NColors=nlevels, Bottom=3

pos = [0.15, 0.15, 0.8, 0.9]

cgContour, dist2D, xx, yy, fill=not keyword_set(logs),cell_Fill=keyword_set(logs), C_Colors=Indgen(nlevels)+3, Background=cgColor('white'), $
         Levels=levels,position=pos,$
         Color=cgColor('black'),xtitle=xtitle,ytitle=ytitle ;,/noerase

cgContour, dist2D, xx, yy, /Overplot, Levels=levels, Color=cgColor('black'),/noerase,/Follow,C_LABELS=0
oplot,[-1,1],[0,0],color=1,linestyle=1
oplot,[0,0],[-1,1],color=1,linestyle=1
SetDecomposedState, state
cgColorBar, NColors=nlevels, Bottom=3, Divisions=6, $
             Format='(I6)', $
            AnnotateColor='black',/vertical,ylog=logs,range=range,yticks=0


END


PRO VIEW_DIST,specie,i0,j0,tindex=tindex,logs=logs

if not keyword_set(tindex) then $
   tindex = 146240

;path='/net/nfs/pandora//cluster11/yhliu/oxygen-run1/distributions/data/'
path='/Volumes/Liu/oxygen-run1/distributions/dist'+strtrim(string(tindex),2)+'/'
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

;arrange_plots,x0,y0,x1,y1,nx=2,ny=2,xgap=0.1,ygap=.1

if !d.window ne -1 then begin
   for i=0,!d.window do begin
      wdelete,i
   endfor
endif


show_dist,dist,vx=vx,vy=vy,logs=keyword_set(logs) ,angle=20 ;,pos=[x0[0],y0[0],x1[0],y1[0]]
show_dist,dist,vx=vx,vz=vz,logs=keyword_set(logs),dist2d=dist2d,angle=20 ;,dist2=dist2d ;,pos=[x0[1],y0[1],x1[1],y1[1]],dist2d=dist2d
show_dist,dist,vy=vy,vz=vz,logs=keyword_set(logs),angle=20 ;,pos=[x0[2],y0[2],x1[2],y1[2]]
window,!d.window+1,xsize=600,ysize=400 ,title='vx-vz'
loadct2,33
shade_surf,dist2d,vx,vz,ax=30,az=60,charsize=2,zstyle=0,xtitle='vx',ytitle='vz';,position=[x0[3],y0[3],x1[3],y1[3]] ;,/noerase

;stop
END
