
PRO show_dist,dist,vx=vx,vy=vy,vz=vz


if keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then begin
   dist2D=total(dist,3)
   xx=vx
   yy=vy
   title='vx-vy'
endif

if keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then begin
   dist2D=total(dist,2)
   xx=vx
   yy=vz
   title='vx-vz'
endif

if keyword_set(vx) and keyword_set(vy) and not keyword_set(vz) then begin
   dist2D=total(dist,1)
   xx=vy
   yy=vz
   title='vy-vz'
endif

cgDisplay,600,400,title='vx-vz'
LoadCT, 33, NColors=12, Bottom=3



levels = 12


SetDecomposedState, 0, CurrentState=state
cgContour, dist2D_xy, vx, vy, /Fill, C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
         NLevels=levels, Position=[0.1, 0.1, 0.9, 0.80], Color=cgColor('black'),xtitle='Vx',ytitle='Vy'
Contour, dist2D_xy, vx, vy, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
SetDecomposedState, state
cgColorBar, NColors=12, Bottom=3, Divisions=6, $
            Range=range_xy, Format='(I5.2)', $
            Position = [0.1, 0.9, 0.9, 0.95], AnnotateColor='black';,/ylog

END


PRO VIEW_DIST,specie,i0,j0,tindex=tindex

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


;dist2D_xy = alog10(total(dist,3));
;dist2D_xz = alog10(total(dist,2));
;dist2D_yz = alog10(total(dist,1));

dist2D_xy = total(dist,3);
dist2D_xz = total(dist,2);
dist2D_yz = total(dist,1);

ind=where(dist2D_xy le 0)
dist2D_xy[ind]=!values.f_nan

ind=where(dist2D_xz le 0)
dist2D_xz[ind]=!values.f_nan

ind=where(dist2D_yz le 0)
dist2D_yz[ind]=!values.f_nan

window,0,xsize=600,ysize=600
;cgDisplay,600,400,title='vx-vz'
LoadCT, 33, NColors=12, Bottom=3

range_xy=[Min(dist2D_xy,/nan), Max(dist2D_xy,/nan)]
range_xz=[Min(dist2D_xz,/nan), Max(dist2D_xz,/nan)]
range_yz=[Min(dist2D_yz,/nan), Max(dist2D_yz,/nan)]
;STOP
levels = 12


SetDecomposedState, 0, CurrentState=state
cgContour, dist2D_xy, vx, vy, /Fill, C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
         NLevels=levels, Position=[0.1, 0.1, 0.9, 0.80], Color=cgColor('black'),xtitle='Vx',ytitle='Vy'
Contour, dist2D_xy, vx, vy, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
SetDecomposedState, state
cgColorBar, NColors=12, Bottom=3, Divisions=6, $
            Range=range_xy, Format='(I5.2)', $
            Position = [0.1, 0.9, 0.9, 0.95], AnnotateColor='black';,/ylog
window,1,xsize=600,ysize=600
LoadCT, 33, NColors=12, Bottom=3
levels = 12
SetDecomposedState, 0, CurrentState=state
cgContour, dist2D_xz, vx, vz, /Fill, C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
         NLevels=levels, Position=[0.1, 0.1, 0.9, 0.80], Color=cgColor('black'),xtitle='Vx',ytitle='Vz'
Contour, dist2D_xz, vx, vz, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
SetDecomposedState, state
cgColorBar, NColors=12, Bottom=3, Divisions=6, $
            Range=range_xz, Format='(I5.2)', $
            Position = [0.1, 0.9, 0.9, 0.95], AnnotateColor='black'


window,2,xsize=600,ysize=600
LoadCT, 33, NColors=12, Bottom=3
levels = 12
SetDecomposedState, 0, CurrentState=state
cgContour, dist2D_yz, vy, vz, /Fill, C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
         NLevels=levels, Position=[0.1, 0.1, 0.9, 0.80], Color=cgColor('black'),xtitle='Vy',ytitle='Vz'
Contour, dist2D_yz, vy, vz, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
SetDecomposedState, state
cgColorBar, NColors=12, Bottom=3, Divisions=6, $
            Range=range_yz, Format='(I5.2)', $
            Position = [0.1, 0.9, 0.9, 0.95], AnnotateColor='black'

STOP
END
