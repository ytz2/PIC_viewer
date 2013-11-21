PRO PLOT_PAPER3

step=146240
OPENGDA,step
vae=0.7443
vai=0.1944
vao=0.0812
nh=0.0533965
no=0.0330580
b0= 0.42
va_t=b0/sqrt(nh*50+no*500)

restore,f='/Volumes/Liu/oxygen-run1/eagyrotropy.sav'
restore,f='/Volumes/Liu/oxygen-run1/iagyrotropy.sav'
restore,f='/Volumes/Liu/oxygen-run1/oagyrotropy.sav'
vex=get_quantity('uex',step)/vae
vix=get_quantity('uix',step)/vai
vox=get_quantity('uox',step)/vao
by=get_quantity('by',step)/b0
ez=get_quantity('ez',step)/(b0*va_t)

popen,'/Users/yanhualiu/Desktop/test.ps',/port
plot_multi_quantity,[],step,$
                    extra_quantity={by:by,$
                                    eagy:smooth(eagy,3,/nan),$
                                    iagy:smooth(iagy,3,/nan), $
                                    oagy:smooth(oagy,3,/nan)},$
                    dim=[500,1500,-250,250],ay="by",$
                    cbar={by:[-0.6,0.6],$
                         eagy:[-0.5,2],$
                          iagy:[-0.5,2],$
                          oagy:[-0.5,2]},/print
                 
pclose

popen,'/Users/yanhualiu/Desktop/test2.ps',/port
plot_multi_quantity,[],step,$
                    extra_quantity={ez:ez,$
                                    vex:vex,$
                                    vix: vix, $
                                    vox:vox},$
                    dim=[500,1500,-250,250],$
                    cbar={ez:[-2.25,2.25],$
                          vex:[-1.,1.],$
                          vix:[-1.,1.],$
                          vox:[-1.,1.]},/print
                 
pclose
stop
stop
END
