

PRO SLICE_CUT,DATA,DIM,NCUT,X=X,Z=Z,range=range

if keyword_set(X) and not keyword_set(z) then begin
   sep=(dim[1]-dim[0])/ncut
   cut_at=scale_vector(findgen(ncut),dim[0]+0.5*sep,dim[1]-0.5*sep)
   arr=linespace(dim=dim,/z)
endif
if not keyword_set(X) and keyword_set(z) then begin
   sep=(dim[3]-dim[2])/ncut
   cut_at=scale_vector(findgen(ncut),dim[2]+0.5*sep,dim[3]-0.5*sep)
   arr=linespace(dim=dim,/x)
endif

if not keyword_set(X) and not keyword_set(z) then begin
   message,'Set keyword /x or /z'
   goto, next
endif 

if not keyword_set(range) then begin
   data_max=max(data)
   range=[-data_max,data_max]
endif
colors=[-1, 1+indgen(ncut-1)]
loadct2,33
for i=0,n_elements(cut_at)-1 do begin
   if keyword_set(x) then oplot,[cut_at[i],cut_at[i]],[-2000,2000],color=colors[i]
   if keyword_set(z) then oplot,[-2500,2500],[cut_at[i],cut_at[i]],color=colors[i]
endfor

window,!D.WINDOW +1,xsize=1200,ysize=800

if keyword_set(x) then begin
   plot,arr,map_data(data=data,xcut=cut_at[0],dim=dim), $
        xtitle='Z',ytitle='Data',color=colors[0],yrange=range

   for i=1,n_elements(cut_at)-1 do begin
      oplot,arr,map_data(data=data,xcut=cut_at[i],dim=dim),color=colors[i]
   endfor
endif

if keyword_set(z) then begin
   plot,arr,map_data(data=data,zcut=cut_at[0],dim=dim), $
        xtitle='X',ytitle='Data',color=colors[0],yrange=range

   for i=1,n_elements(cut_at)-1 do begin
      oplot,arr,map_data(data=data,zcut=cut_at[i],dim=dim),color=colors[i]
   endfor
endif

items='Cut at '+strtrim(cut_at,2)
legend,items,textcolors=colors,/right,/top,charsize=1. 
next:
reload_ct

END
