PRO PLOT_DATA, print=print
;-----------------------------------------
;Parameter 
;-----------------------------------------

tlist=get_tlist()
step=146240; tlist[7]
;step=28334
;step=48442
cut_at=1600.
;dim=[1400,1700,-100,100]
;dim=[1000,1500,-300,300]
;dim=[1200,1500,-50,50]
dim=[500,2000,-300,300]
;-----------------------------------------
;Open and plot
;-----------------------------------------

opengda,step ; open .gda files
print, step

restore,filename='/Volumes/Liu/oxygen-run1/e_diffusion'
er=calc_er('e','y',step)/0.004
uex=get_quantity('uex',step)/2.236068e-1
by=get_quantity('by',step)/0.5

thm_init,/reset

xarr=linespace(/x,dim=dim)
!p.charsize=1.5
!P.multi=[0,1,3]
PS_START,FILENAME='/Users/yanhualiu/Desktop/cut.ps'
plot,xarr,map_data(data=uex,zcut=0,dim=dim)
oplot,[0,2000],[1,1],linestyle=1,color=2,thick=2
oplot,[0,2000],[-1,-1],linestyle=1,color=2,thick=2
plot,xarr,map_data(data=smooth(e_diffusion,10),zcut=0,dim=dim)
plot,xarr,map_data(data=smooth(er,20),zcut=0,dim=dim)
oplot,[0,2000],[0,0],linestyle=1,color=2,thick=2
pclose
stop
;PS_START,FILENAME='/Users/yanhualiu/Desktop/operp.ps'
plot_multi_quantity,$
   [],step,$
   extra_quantity={ueex:uex,bby:by,ediff:e_diffusion,$
                   er:smooth(er,20)}, $
   dim=dim ,$
   cbar={ueex:[-3.,3.],bby:[-0.6,0.6],ediff:[-0.1,0.4],er:[-2.,2.]};,/print
;PS_END
stop

vx=velocity_perp('e','x',step)
vy=velocity_perp('e','y',step)
vz=velocity_perp('e','z',step)
btot=(get_quantity('absB',step))^2
ecrossbx=cross_field('e','b','x',step)/btot
ecrossby=cross_field('e','b','y',step)/btot
ecrossbz=cross_field('e','b','z',step)/btot
e_diffusion=sqrt((vx-ecrossbx)^2.+(vy-ecrossby)^2.+(vz-ecrossbz)^2.)

stop
plot_multi_quantity,$
   [],step,$
   extra_quantity={ox:velocity_perp('o','x',step),$
                   oy:velocity_perp('o','y',step),$
                   oz:velocity_perp('o','z',step)}, $
   /ay,dim=dim,$
   cbar={ox:[-0.2,0.2],oy:[-0.2,0.2],oz:[-0.2,0.2]}

stop
plot_contour,'by',step,dim=dim,/ay
stop
goto,next
product='uo'
v_dot_b=dot_field(product,'b',step)
absV=abs_quantity(product,step)
absB=get_quantity('absB',step)

asine=asin(v_dot_b/(absV*absB))*180./!pi

plot_contour,indata=asine,product+" pitch angle ",$
             step,dim=dim,/ay,bar_low=-90.,bar_up=90.


stop
plot_multi_quantity,['ex','ey','ez'],step,dim=dim
plot_multi_quantity,['bx','by','bz'],step,dim=dim



stop
rho=get_quantity('ni',step)+get_quantity('no',step)-get_quantity('ne',step)

jx=get_quantity('jx',step)
jy=get_quantity('jy',step)
jz=get_quantity('jz',step)
diffusion_e=jx*calc_er('e','x',step)+jy*calc_er('e','y',step)+jz*calc_er('e','z',step)-rho*dot_field('ue','e',step)
diffusion_i=jx*calc_er('i','x',step)+jy*calc_er('i','y',step)+jz*calc_er('i','z',step)-rho*dot_field('ui','e',step)
diffusion_o=jx*calc_er('o','x',step)+jy*calc_er('o','y',step)+jz*calc_er('o','z',step)-rho*dot_field('uo','e',step)

plot_multi_quantity,$
   [],step,$
   extra_quantity={e:diffusion_e,$
                   i:diffusion_i,$
                   o:diffusion_o} , $
   dim=dim,/ay

stop






btot=(get_quantity('absB',step))^2
ecrossbx=cross_field('e','b','x',step)/btot
ecrossby=cross_field('e','b','y',step)/btot
ecrossbz=cross_field('e','b','z',step)/btot


plot_multi_quantity,$
   [],step,$
   extra_quantity={x:ecrossbx,$
                   y:ecrossby,$
                   z:ecrossbz}, $
   /ay,dim=dim,$
   cbar={x:[-0.2,0.2],y:[-0.2,0.2],z:[-0.2,0.2]}

stop

PS_START,FILENAME='/Users/yanhualiu/Desktop/eperp.ps'

plot_multi_quantity,$
   [],step,$
   extra_quantity={ex:velocity_perp('e','x',step),$
                   ey:velocity_perp('e','y',step),$
                   ez:velocity_perp('e','z',step)}, $
   /ay,dim=dim,$
   cbar={ex:[-0.2,0.2],ey:[-0.2,0.2],ez:[-0.2,0.2]},/print
PS_END 
PS_START,FILENAME='/Users/yanhualiu/Desktop/iperp.ps'
plot_multi_quantity,$
   [],step,$
   extra_quantity={ix:velocity_perp('i','x',step),$
                   iy:velocity_perp('i','y',step),$
                   iz:velocity_perp('i','z',step)}, $
   /ay,dim=dim,$
   cbar={ix:[-0.2,0.2],iy:[-0.2,0.2],iz:[-0.2,0.2]},/print
PS_END
PS_START,FILENAME='/Users/yanhualiu/Desktop/operp.ps'
plot_multi_quantity,$
   [],step,$
   extra_quantity={ox:velocity_perp('o','x',step),$
                   oy:velocity_perp('o','y',step),$
                   oz:velocity_perp('o','z',step)}, $
   /ay,dim=dim,$
   cbar={ox:[-0.2,0.2],oy:[-0.2,0.2],oz:[-0.2,0.2]},/print
PS_END
stop

jx=get_quantity('jx',step)
jy=get_quantity('jy',step)
jz=get_quantity('jz',step)
diffusion=jx*calc_er('e','x',step)+jy*calc_er('e','y',step)+jz*calc_er('e','z',step)
stop
plot_contour,indata=diffusion,'j.E',step,dim=dim,/ay
stop
diffusion=jx*calc_er('i','x',step)+jy*calc_er('i','y',step)+jz*calc_er('i','z',step)
plot_contour,indata=abs(diffusion),'j.E',step,dim=dim,/ay
stop
diffusion=jx*calc_er('o','x',step)+jy*calc_er('o','y',step)+jz*calc_er('o','z',step)
plot_contour,indata=abs(diffusion),'j.E',step,dim=dim,/ay
stop





plot_multi_quantity,$
   ['jy'],step,$
   extra_quantity={eex:calc_er('e','x',step),eey:calc_er('e','y',step),eez:calc_er('e','z',step)} , $
   cbar={jy:[-0.02,0.04]/2,eex:[-0.1,0.1]/2,eey:[-0.03,0.03]/2,eez:[-0.1,0.1]/2},dim=dim

stop


plot_multi_quantity,$
   ['jy'],step,$
   extra_quantity={eix:calc_er('i','x',step),eiy:calc_er('i','y',step),eiz:calc_er('i','z',step)}, $
   cbar={jy:[-0.02,0.04],eix:[-0.1,0.1],eiy:[-0.03,0.03],eiz:[-0.1,0.1]},dim=dim

stop
plot_multi_quantity,$
   ['jy'],step,$
   extra_quantity={eox:calc_er('o','x',step),eoy:calc_er('o','y',step),eoz:calc_er('o','z',step)}, $
   cbar={jy:[-0.02,0.04],eox:[-0.1,0.1],eoy:[-0.03,0.03],eoz:[-0.1,0.1]},dim=dim

stop

plot_multi_quantity,$
   ['uex','uix','uox'],step

next:
jx=get_quantity('jx',step)
jy=get_quantity('jy',step)
jz=get_quantity('jz',step)
diffusion=jx*calc_er('e','x',step)+jy*calc_er('e','y',step)+jz*calc_er('e','z',step)
plot_contour,indata=abs(diffusion),'j.E',step,dim=dim
stop
diffusion=jx*calc_er('i','x',step)+jy*calc_er('i','y',step)+jz*calc_er('i','z',step)
plot_contour,indata=abs(diffusion),'j.E',step,dim=dim
stop
diffusion=jx*calc_er('o','x',step)+jy*calc_er('o','y',step)+jz*calc_er('o','z',step)
plot_contour,indata=abs(diffusion),'j.E',step,dim=dim
stop

plot_contour,'by',step,dim=dim ;,bar_low=-0.02,bar_up=0.04

stop
PLOT_PATTERN,'e',step,dim=dim,smth=8,grid=[50,40],length=0.03
stop
;plot_contour,'by',step,dim=dim ,/ay;,/over_log
;PLOT_PATTERN,'e',step,dim=dim,smth=8,grid=[50,40],length=0.03
;PLOT_PATTERN,'i',step,dim=dim,smth=8,frt=0.002 ,length=0.05

plot_contour,indata=calc_ey('i',step),'Ey',step,$
                  dim=dim ;,bar_zlow=-0.01,bar_up=0.06
stop
plot_contour,indata=calc_ey('e',step),'Ey',step,$
                  dim=dim
plot_contour,indata=calc_ey('o',step),'Ey',step,$
                  dim=dim


;SIMULATE_OBSERVE, step
close,/All

free_lun, 1

stop
END
