

PRO PLOT_BYCUT

;----------------------------------------------------------------
;Set up the parameters
;----------------------------------------------------------------

;cut_at=[100,500,1600,2100]
n_line=3
cut_at=scale_vector(findgen(n_line),1500.,2000.)
colors=[-1, 1+indgen(n_line-1)]
dim=[0,2230,-500,500]
tlist=[24678,46157, 88201,62609,109223, 128417, 145783 ]
step=tlist[3]

;----------------------------------------------------------------
;Read data
;----------------------------------------------------------------

opengda,step,/notv ; open .gda files

;plot_contour,'by',step,dim=dim
zarr=linespace(dim=dim,/z)
beta=get_quantity('beta',step)
bx=get_quantity('bx',step)
by=get_quantity('by',step)

;----------------------------------------------------------------
;Do plot
;----------------------------------------------------------------

items='Cut at '+strtrim(cut_at,2)

window,!D.WINDOW +1,xsize=1200,ysize=800
loadct2,33
!p.multi = [0, 3, 2]

!p.charsize=2.

;----------------------------------------------------------------
;plot Z VS Bx
;----------------------------------------------------------------

plot,zarr,map_data(data=bx,xcut=cut_at[0],dim=dim), $
     xtitle='Z',ytitle='Bx',color=colors[0],title='Bx vs Z'

for i=1,n_elements(cut_at)-1 do begin
   oplot,zarr,map_data(data=bx,xcut=cut_at[i],dim=dim),color=colors[i]
endfor

oplot,[-1e4,1e4],[0,0] 
oplot,[0,0],[-1e4,1e4] 


;legend,items,textcolors=colors,/right,/top,charsize=1.3 

;stop

;----------------------------------------------------------------
;plot z vs by
;----------------------------------------------------------------
plot,zarr,map_data(data=by,xcut=cut_at[0],dim=dim), $
     xtitle='Z',ytitle='By',color=colors[0],title='By vs Z'

for i=1,n_elements(cut_at)-1 do begin
   oplot,zarr,map_data(data=by,xcut=cut_at[i],dim=dim),color=colors[i]
endfor
oplot,[-1e4,1e4],[0,0] 
oplot,[0,0],[-1e4,1e4] 

;legend,items,textcolors=colors,/right,/top,charsize=1.3 

;stop

;----------------------------------------------------------------
;plot z vs bx/beta+1
;----------------------------------------------------------------
bx_temp=map_data(data=bx,xcut=cut_at[0],dim=dim)
by_temp= map_data(data=by,xcut=cut_at[0],dim=dim)
beta_temp=map_data(data=beta,xcut=cut_at[0],dim=dim)
xx_temp=bx_temp/abs(bx_temp)/(1.+beta_temp)

plot,zarr,xx_temp, $
     xtitle='Z',ytitle='norm factor',color=colors[0],yrange=[-1,1] $
     ,title='norm vs Z'

for i=1,n_elements(cut_at)-1 do begin
   bx_temp=map_data(data=bx,xcut=cut_at[i],dim=dim)
   by_temp= map_data(data=by,xcut=cut_at[i],dim=dim)
   beta_temp=map_data(data=beta,xcut=cut_at[i],dim=dim)
   xx_temp=bx_temp/abs(bx_temp)/(1.+beta_temp)
   oplot,zarr,xx_temp,color=colors[i]
endfor

oplot,[-1e4,1e4],[0,0] 
oplot,[0,0],[-1e4,1e4] 


;legend,items,textcolors=colors,/right,/top,charsize=1.3 

;stop

;----------------------------------------------------------------
;plot bx vs by
;----------------------------------------------------------------

plot,map_data(data=bx,xcut=cut_at[0],dim=dim), $
     map_data(data=by,xcut=cut_at[0],dim=dim),xtitle='Bx',ytitle='By',$
     yrange=[min(by)/2.,max(by)/2.],color=colors[0],title='By vs Bx'

for i=1,n_elements(cut_at)-1 do begin
   oplot,map_data(data=bx,xcut=cut_at[i],dim=dim),map_data(data=by,xcut=cut_at[i],dim=dim),color=colors[i]
endfor
oplot,[-1e4,1e4],[0,0] 
oplot,[0,0],[-1e4,1e4] 


;legend,items,textcolors=colors,/right,/top,charsize=1.3 

;----------------------------------------------------------------
;add legend
;----------------------------------------------------------------
plot,[0],[0],xstyle=4,ystyle=4  
legend,items,textcolors=colors,/center,charsize=1.3 

;stop

;----------------------------------------------------------------
;plot bx/beta+1 vs by
;----------------------------------------------------------------
bx_temp=map_data(data=bx,xcut=cut_at[0],dim=dim)
by_temp= map_data(data=by,xcut=cut_at[0],dim=dim)
beta_temp=map_data(data=beta,xcut=cut_at[0],dim=dim)
xx_temp=bx_temp/abs(bx_temp)/(1.+beta_temp)
plot,xx_temp,by_temp,xtitle='(Bx/|Bx|)*(1/b+1)', $
     ytitle='By',yrange=[min(by)/2.,max(by)/2.],$
     color=colors[0],title='By vs Normalize'

for i=1,n_elements(cut_at)-1 do begin
   bx_temp=map_data(data=bx,xcut=cut_at[i],dim=dim)
   by_temp= map_data(data=by,xcut=cut_at[i],dim=dim)
   beta_temp=map_data(data=beta,xcut=cut_at[i],dim=dim)
   xx_temp=bx_temp/abs(bx_temp)/(1.+beta_temp)
   oplot,xx_temp,by_temp,color=colors[i]
endfor
oplot,[-1e4,1e4],[0,0] 
oplot,[0,0],[-1e4,1e4] 


close,/all
free_lun, 1


;----------------------------------------------------------------
;overall look about the data
;----------------------------------------------------------------
!p.charsize=2.0
opengda,step
plot_contour,'by',step,dim=dim,/ay
for i=0,n_line-1 do oplot,[cut_at[i],cut_at[i]],[-1e4,1e4],linestyle=2


close,/all
free_lun, 1

;legend,items,textcolors=colors,/right,/top,charsize=1.3 

STOP
END
