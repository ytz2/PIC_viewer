PRO PLOT_CUT

step=145783
dim=[0,2230,-500,500]
ncuts=6
nsmooth=8

opengda,step
xarr=linespace(/x)
vpx=get_quantity('uix',step)
vex=get_quantity('uex',step)
vox=get_quantity('uox',step)

vpy=get_quantity('uiy',step)
vey=get_quantity('uey',step)
voy=get_quantity('uoy',step)

vpz=get_quantity('uiz',step)
vez=get_quantity('uez',step)
voz=get_quantity('uoz',step)


n_electron=get_quantity('ne',step)
n_proton=get_quantity('ni',step)
n_oxygen=get_quantity('no',step)

colors=[-1, 1,2]
cut_at=scale_vector(findgen(ncuts),dim[2],dim[3])
cut_at=[0]
;----------------------------------------------------------------
;Do plot
;----------------------------------------------------------------


loadct2,33


!p.charsize=2.


for i=0,n_elements(cut_at)-1,1 do begin
   tlt="cut="+strtrim(string(cut_at[i]),1)

;----------------------------------------------------------------
;plot X vs Vi
;----------------------------------------------------------------
   window,!D.WINDOW +1,xsize=1200,ysize=800
   !p.multi = [0, 1, 3]
   v1=smooth(map_data(data=vex,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=vpx,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=vox,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='vx',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   legend,['e-','H+','O+'],colors=colors,linestyle=[0,0,0],charsize=1.,/right
   oplot,[0,1e4],[0,0],linestyle=3
   

   v1=smooth(map_data(data=vey,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=vpy,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=voy,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='vy',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   oplot,[0,1e4],[0,0],linestyle=3
   

   v1=smooth(map_data(data=vez,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=vpz,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=voz,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='vz',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   oplot,[0,1e4],[0,0],linestyle=3

   stop

;----------------------------------------------------------------
;plot X vs Vspecie
;----------------------------------------------------------------
   window,!D.WINDOW +1,xsize=1200,ysize=800

   !p.multi = [0, 1, 3]
   v1=smooth(map_data(data=vex,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=vey,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=vez,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]

   plot,Xarr,v1, $
        xtitle='X',ytitle='Ve',color=colors[0],$
        xrange=[0,2230],yrange=yrange,xstyle=1,$
        title=tlt
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   legend,['x','y','z'],colors=colors,linestyle=[0,0,0],charsize=1.,/right
   oplot,[0,1e4],[0,0],linestyle=3
   


   v1=smooth(map_data(data=vpx,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=vpy,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=vpz,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='Vi',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   oplot,[0,1e4],[0,0],linestyle=3
   
   v1=smooth(map_data(data=vox,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=voy,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=voz,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='Vo',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   oplot,[0,1e4],[0,0],linestyle=3

;----------------------------------------------------------------
;plot denstiy
;----------------------------------------------------------------
   window,!D.WINDOW +1,xsize=1200,ysize=800

    !p.multi = [0, 1, 1]
   v1=smooth(map_data(data=n_electron,zcut=cut_at[i]),nsmooth)
   v2=smooth(map_data(data=n_proton,zcut=cut_at[i]),nsmooth)
   v3=smooth(map_data(data=n_oxygen,zcut=cut_at[i]),nsmooth)
   y_low=min([min(v1),min(v2),min(v3)])*1.1
   y_up=max([max(v1),max(v2),max(v3)])*1.1
   yrange=[y_low,y_up]
   plot,Xarr,v1, $
        xtitle='X',ytitle='N',color=colors[0],xrange=[0,2230],yrange=yrange,xstyle=1,/ylog
   oplot,Xarr,v2,color=colors[1]
   oplot,Xarr,v3,color=colors[2]
   legend,['e-','H+','O+'],colors=colors,linestyle=[0,0,0],charsize=1.,/right
   oplot,[0,1e4],[0,0],linestyle=3
   
   stop
endfor
END
