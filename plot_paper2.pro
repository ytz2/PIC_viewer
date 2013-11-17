PRO PLOT_PAPER2

STEP=146240
opengda,step


btot=(get_quantity('absB',step))^2

n_smooth=5
n_cut=0
thick_size=1.5
ecrossbx=map_data(data=cross_field('e','b','x',step)/btot,step=step,zcut=n_cut)
jx=map_data(var='jx',step=step,zcut=n_cut)
n_proton=map_data(var='ni',step=step,zcut=n_cut)
n_oxygen=map_data(var='no',step=step,zcut=n_cut)
n_electron=map_data(var='ne',step=step,zcut=n_cut)
vx_proton=map_data(var='uix',step=step,zcut=n_cut)
vx_oxygen=map_data(var='uox',step=step,zcut=n_cut)
vx_electron=map_data(var='uex',step=step,zcut=n_cut)
vpx_proton=map_data(data=velocity_perp('i','x',step),step=step,zcut=n_cut)
vpx_oxygen=map_data(data=velocity_perp('o','x',step),step=step,zcut=n_cut)
vpx_electron=map_data(data=velocity_perp('e','x',step),step=step,zcut=n_cut)
thm_init,/reset
xarr=linespace(/x)


!p.multi=[0,3,1]
!p.charsize=2.

plot,xarr,smooth(jx,n_smooth),xtitle='X (de)', ytitle='Jx',xrange=[500,1500],thick=thick_size
oplot,xarr,smooth(-n_electron*vx_electron,n_smooth),color=1,thick=thick_size
oplot,xarr,smooth(n_proton*vx_proton,n_smooth),color=2,thick=thick_size     
oplot,xarr,smooth(n_oxygen*vx_oxygen,n_smooth),color=6,thick=thick_size
oplot,[0,2000],[0,0],linestyle=1, thick=thick_size 
legend,['Jx','Jex','Jix','Jox'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=1.3,/left

plot,xarr,smooth(ecrossbx,n_smooth*4),xtitle='X (de)', ytitle='Vx',xrange=[500,1500],yrange=[-0.4,0.4],thick=thick_size
oplot,xarr,smooth(vx_electron,n_smooth),color=1,thick=thick_size
oplot,xarr,smooth(vx_proton,n_smooth),color=2,thick=thick_size     
oplot,xarr,smooth(vx_oxygen,n_smooth),color=6,thick=thick_size
oplot,[0,2000],[0,0],linestyle=1, thick=thick_size
legend,['Vexb','Vex','Vix','Vox'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=1.3,/left

plot,xarr,smooth(ecrossbx,n_smooth*4),xtitle='X (de)', ytitle='Vperpx',xrange=[500,1500],yrange=[-0.4,0.4],thick=thick_size
oplot,xarr,smooth(vpx_electron,n_smooth),color=1,thick=thick_size
oplot,xarr,smooth(vpx_proton,n_smooth),color=2 ,thick=thick_size  
oplot,xarr,smooth(vpx_oxygen,n_smooth),color=6,thick=thick_size
oplot,[0,2000],[0,0],linestyle=1, thick=thick_size 
legend,['Vexb','Vperp,ex','Vperp,ix','Vperp,ox'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=1.3,/left

!p.multi=[0,1,1]
stop
close,/all
END
