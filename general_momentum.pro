PRO GENERAL_MOMENTUM,STEP,SPECIE

common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

opengda,step
ns=get_quantity('n'+specie,step)
vix=get_quantity('u'+specie+'x',step)
viz=get_quantity('u'+specie+'z',step)
viy=get_quantity('u'+specie+'y',step)
nh=0.0413872
no=0.0239593
b0=0.299664
va=b0/sqrt(nh*50+no*500)
restore,filename='/Volumes/Liu/oxygen-run1/o_diffusion'

;mndv_dt=-mnvidvi_dx-divp+ne(e+vxb)

;------------------------------------------
;prepare
;------------------------------------------
dx=xmax/nx
dz=zmax/nz
mass=0
case specie of
   'e': mass=1.
   'i': mass=50.
   'o': mass=500.
endcase



;plot_contour,'O DR',step,indata=smooth(o_diffusion,5)/va,bar_low=-0.5,bar_up=3,dim=[600,1400,-200,200]

;TRACE_ELEMENT,STEP,specie,[1100,100],xpath=xpath,zpath=zpath,limit=600,xind=xind,zind=zind


;term 1

;xcomponent
em_x=ns*calc_er(specie,'x',step)/(va*b0)
eucidian_x=-mass*ns*(vix*pdiv(vix,1,order=1)+viz*pdiv(vix,1,order=1))/(va*b0)
pixx_x=-pdiv(get_quantity('p'+specie+'-xx',step),1,order=1)/(va*b0)
pixz_x=-pdiv(get_quantity('p'+specie+'-xz',step),2,order=1)/(va*b0)

em_y=ns*calc_er(specie,'y',step)/(va*b0)
eucidian_y=-mass*ns*(vix*pdiv(viy,1,order=3)+viz*pdiv(viy,1,order=1))/(va*b0)
pixy_y=-pdiv(get_quantity('p'+specie+'-xy',step),1,order=1)/(va*b0)
piyz_y=-pdiv(get_quantity('p'+specie+'-yz',step),2,order=1)/(va*b0)


em_z=ns*calc_er(specie,'z',step)/(va*b0)
eucidian_z=-mass*ns*(vix*pdiv(viz,1,order=3)+viz*pdiv(viz,1,order=1))/(va*b0)
pixz_z=-pdiv(get_quantity('p'+specie+'-xz',step),1,order=1)/(va*b0)
pizz_z=-pdiv(get_quantity('p'+specie+'-zz',step),2,order=1)/(va*b0)


plot_multi_quantity,[],step,extra_quantity=$
{divPx:smooth(pixx_x+pixz_x,10),EMx:smooth(em_x,20),Force:smooth(em_x+pixx_x+pixz_x,20)},$
cbar={divpx:[-0.05,0.05]/2,emx:[-0.07,0.07]/2,force:[-0.05,0.05]/2},$
dim=[500,2000,-400,400]

stop
plot_multi_quantity,[],step,extra_quantity=$
{divPy:smooth(pixy_y+piyz_y,10),EMy:smooth(em_y,20),Force:smooth(em_y+pixy_y+piyz_y,20)},$
cbar={divpy:[-0.05,0.05]/2,emy:[-0.07,0.07]/2,force:[-0.05,0.05]/2},$
dim=[500,2000,-400,400]


plot_multi_quantity,[],step,extra_quantity=$
{divPz:smooth(pixz_z+pizz_z,10),EMz:smooth(em_z,20),Force:smooth(em_z+pixz_z+pizz_z,20)},$
cbar={divpz:[-0.05,0.05],emz:[-0.07,0.07],force:[-0.05,0.05]},$
dim=[500,2000,-400,400]

stop


;xcomponent
divp_x=-div_p(STEP,'x',specie=specie)/(va*b0)
em_x=ns*calc_er(specie,'x',step)/(va*b0)
force_x=divp_x+em_x
eucidian_x=-mass*ns*(vix*finite_diff(vix,/x)+viz*finite_diff(vix,/z))/(va*b0)
pixx=-finite_diff(get_quantity('p'+specie+'-xx',step),/x)/(va*b0)
pixz=-finite_diff(get_quantity('p'+specie+'-xz',step),/z)/(va*b0)
stop

p_x=(smooth(divp_x,20,/edge_truncate))[xind,zind]
e_x=(smooth(em_x,20,/edge_truncate))[xind,zind]
f_x=(smooth(force_x,20,/edge_truncate))[xind,zind]
eu_x=(smooth(eucidian_x,20,/edge_truncate))[xind,zind]
pixx_x=(smooth(pixx,20,/edge_truncate))[xind,zind]
pixz_x=(smooth(pixz,20,/edge_truncate))[xind,zind]

;zcomponent
divp_z=-div_p(STEP,'z',specie=specie)/(va*b0)
em_z=ns*calc_er(specie,'z',step)/(va*b0)
force_z=divp_z+em_z
eucidian_z=-mass*ns*(vix*finite_diff(viz,/x)+viz*finite_diff(viz,/z))/(va*b0)
pixz=-finite_diff(get_quantity('p'+specie+'-xz',step),/x)/(va*b0)
pizz=-finite_diff(get_quantity('p'+specie+'-zz',step),/z)/(va*b0)


p_z=(smooth(divp_z,20,/edge_truncate))[xind,zind]
e_z=(smooth(em_z,20,/edge_truncate))[xind,zind]
f_z=(smooth(force_z,20,/edge_truncate))[xind,zind]
eu_z=(smooth(eucidian_z,20,/edge_truncate))[xind,zind]
pixz_z=(smooth(pixz,20,/edge_truncate))[xind,zind]
pizz_z=(smooth(pizz,20,/edge_truncate))[xind,zind]


;ycomponent
divp_y=-div_p(STEP,'y',specie=specie)/(va*b0)
em_y=ns*calc_er(specie,'y',step)/(va*b0)
force_y=divp_y+em_y
eucidian_y=-mass*ns*(vix*finite_diff(viy,/x)+viz*finite_diff(viy,/z))/(va*b0)
pixy=-finite_diff(get_quantity('p'+specie+'-xy',step),/x)/(va*b0)
piyz=-finite_diff(get_quantity('p'+specie+'-yz',step),/z)/(va*b0)


p_y=(smooth(divp_y,20,/edge_truncate))[xind,zind]
e_y=(smooth(em_y,20,/edge_truncate))[xind,zind]
f_y=(smooth(force_y,20,/edge_truncate))[xind,zind]
eu_y=(smooth(eucidian_y,20,/edge_truncate))[xind,zind]
pixy_y=(smooth(pixy,20,/edge_truncate))[xind,zind]
piyz_y=(smooth(piyz,20,/edge_truncate))[xind,zind]


thm_init,/reset


!p.charsize=1.2
!x.margin=[3,3]
!y.margin=[2,2]
popen,'momentum.ps',/port

!p.multi=[0,2,3]
plot,xpath,smooth(f_x,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.04,0.04]
oplot,xpath,smooth(p_x,30),color=1,thick=1.5
oplot,xpath,smooth(e_x,30),color=2,thick=1.5
legend,['F!Lx!N','-divP','E+vxB'],colors=[0,1,2],linestyle=[0,0,0],charsize=.8,/right

plot,xpath,smooth(p_x,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.04,0.04]
oplot,xpath,smooth(pixx_x,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(pixz_x,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxx/dx','-dpxz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=0.8,/right


plot,xpath,smooth(f_y,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.06,0.08]
oplot,xpath,smooth(p_y,30),color=1,thick=1.5
oplot,xpath,smooth(e_y,30),color=2,thick=1.5
legend,['F!Ly!N','-divP','E+vxB'],colors=[0,1,2],linestyle=[0,0,0],charsize=.8,/right

plot,xpath,smooth(p_y,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.06,0.08]
oplot,xpath,smooth(pixy_y,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(piyz_y,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxy/dx','-dpyz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=0.8,/right




plot,xpath,smooth(f_Z,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.1,0.1]
oplot,xpath,smooth(p_Z,30),color=1,thick=1.5
oplot,xpath,smooth(e_Z,30),color=2,thick=1.5
legend,['F!Lz!N','-divP','E+vxB'],colors=[0,1,2],linestyle=[0,0,0],charsize=.8,/right

plot,xpath,smooth(p_z,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.1,0.1]
oplot,xpath,smooth(pixz_z,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(pizz_z,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxz/dx','-dpzz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=.8,/right

pclose
stop



popen,'path_v.ps'

!p.charsize=2.
!p.multi=[0,1,3]
!y.margin=[5,5] 
!x.margin=[5,5] 
plot,xpath,smooth(vix[xind,zind],5),xrange=[1200,600],xtitle='x',ytitle='uox'
plot,xpath,smooth(viy[xind,zind],5),xrange=[1200,600],xtitle='x',ytitle='uoy'
plot,xpath,smooth(viz[xind,zind],5),xrange=[1200,600],xtitle='x',ytitle='uoz'
pclose


!p.charsize=1.2
!x.margin=[3,3]
!y.margin=[2,2]
popen,'momentum.ps',/port

!p.multi=[0,2,3]
plot,xpath,smooth(f_x+eu_x,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.04,0.04]
oplot,xpath,smooth(p_x,30),color=1,thick=1.5
oplot,xpath,smooth(e_x,30),color=2,thick=1.5
oplot,xpath,smooth(eu_X,30),color=6,thick=1.5
legend,['!9D!3v!Lx!n/!9D!3t','-divP','E+vxB','v.gradv'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=.8,/right

plot,xpath,smooth(p_x,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.04,0.04]
oplot,xpath,smooth(pixx_x,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(pixz_x,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxx/dx','-dpxz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=0.8,/right


plot,xpath,smooth(f_y+eu_y,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.06,0.08]
oplot,xpath,smooth(p_y,30),color=1,thick=1.5
oplot,xpath,smooth(e_y,30),color=2,thick=1.5
oplot,xpath,smooth(eu_y,30),color=6,thick=1.5
legend,['!9D!3v!Ly!n/!9D!3t','-divP','E+vxB','v.gradv'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=.8,/right

plot,xpath,smooth(p_y,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.06,0.08]
oplot,xpath,smooth(pixy_y,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(piyz_y,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxy/dx','-dpyz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=0.8,/right




plot,xpath,smooth(f_Z+eu_x,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.1,0.1]
oplot,xpath,smooth(p_Z,30),color=1,thick=1.5
oplot,xpath,smooth(e_Z,30),color=2,thick=1.5
oplot,xpath,smooth(eu_Z,30),color=6,thick=1.5
legend,['!9D!3v!Lz!n/!9D!3t','-divP','E+vxB','v.gradv'],colors=[0,1,2,6],linestyle=[0,0,0,0],charsize=.8,/right

plot,xpath,smooth(p_z,30),xrange=[1100,650],thick=1.5,xtitle='x',yrange=[-0.1,0.1]
oplot,xpath,smooth(pixz_z,30),color=1,thick=1.5,linestyle=2
oplot,xpath,smooth(pizz_z,30),color=2,thick=1.5,linestyle=2
legend,['-divP','-dpxz/dx','-dpzz/dz'],colors=[0,1,2],linestyle=[0,2,2],charsize=.8,/right

stop







pclose
stop

END
