PRO PLOT_PAPER,STEP


opengda,step
;va=2.236068e-01
va=0.08
b0=0.5


nh=0.0413872
no=0.0239593
b0=0.299664
va=b0/sqrt(nh*50+no*500)



by=get_quantity('by',step)/b0
ex=smooth(get_quantity('ex',step)/(B0*VA),5)
ez=smooth(get_quantity('ez',step)/(b0*va),5)
ratio=alog10(get_quantity('no',step)/get_quantity('ni',step))
jx=get_quantity('jx',step)/((nh+no)*va)
ey=CALC_ER('e', 'y',STEP)/(va*b0)

restore,filename='/Volumes/Liu/oxygen-run1/e_diffusion'
restore,filename='/Volumes/Liu/oxygen-run1/o_diffusion'
restore,filename='/Volumes/Liu/oxygen-run1/h_diffusion'


stop
ps_start,filename='/Users/yanhualiu/Desktop/test.ps'
plot_multi_quantity,[],step,$
                    extra_quantity={by:smooth(by,5),$
                                    ez:smooth(ez,5),$
                                    h:smooth(h_diffusion,5)/va,$
                                    o:smooth(o_diffusion,5)/va, $
                                    e: smooth(e_diffusion,5)/va, $
                                    ey:smooth(ey,5)}, $
                    dim=[500,1500,-250,250], $
                    cbar={h:[-0.5,3],o:[-.5,3],by:[-0.65,0.65],e:[-0.5,5],ey:[-.5,.5]},/print
PS_END
stop

ps_start,filename='/Users/yanhualiu/Desktop/figure2.ps'
  plot_multi_quantity,[],step,$
     extra_quantity={h:smooth(h_diffusion,5)/va,o:smooth(o_diffusion,5)/va}, $
                      dim=[400,2100,-250,250], $
                      cbar={h:[-0.5,3],o:[-0.5,3]},/print

xcut=[1300,700,900,1100]
zcut=[-30,-30,-30,-30]
for l=0,3 do begin
   PLOT_CUT_DIST,step,xcut=xcut[l],zcut=zcut[l],/nostop,/sav,path='/Users/yanhualiu/Desktop/'
   ;stop
endfor
;,pattern=['e','i','o'] ;,/print  ;,$
PS_END

ps_start,filename='/Users/yanhualiu/Desktop/figure2_2.ps'
  plot_multi_quantity,[],step,$
     extra_quantity={o:smooth(o_diffusion,5)/va,h:smooth(h_diffusion,5)/va}, $
                      dim=[400,2100,-250,250], $
                      cbar={o:[-0.5,3],h:[-0.5,3]},/print

xcut=[1310,1240,1170,1100]
zcut=[-30,-30,-30,-30]
for l=0,3 do begin
   PLOT_CUT_DIST,step,xcut=xcut[l],zcut=zcut[l],/nostop,/sav,path='/Users/yanhualiu/Desktop/'
   ;stop
endfor
;,pattern=['e','i','o'] ;,/print  ;,$
PS_END

stop

ps_start,filename='/Users/yanhualiu/Desktop/figure2_2.ps'
  plot_multi_quantity,[],step,$
     extra_quantity={h:smooth(h_diffusion,5)/va,o:smooth(e_diffusion,5)/va}, $
                      dim=[400,2100,-250,250], $
                      cbar={h:[-0.5,3],o:[-0.5,5]},/print
PS_END

stop
ps_start,filename='/Users/yanhualiu/Desktop/figure1.ps'
plot_multi_quantity,[],step,$
     extra_quantity={by:by,ex:ex,ez:ez,ratio:ratio}, $
                      dim=[400,2100,-250,250],ay=['by'], $
                      cbar={ratio:[-2,2],by:[-1.,1.],ex:[-1,1],ez:[-2,2]},/print
;,pattern=['e','i','o'] ;,/print  ;,$
PS_END

stop




end
