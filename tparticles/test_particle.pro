
PRO PLOT_DIST, data,$
               starts,ends,totalstep,$
               quantity,path

for step=0,totalstep-1 do begin
   datax=[]
   datay=[]
   vy=[]
   for i=starts,ends do begin
      datax=[datax,data[i*6,step]]
      datay=[datay,data[i*6+2,step]]
      vy=[vy,data[i*6+4,step]]
   endfor
   ;PS_START,FILENAME=path+string(format='(i05)',step)+'_oxygen.ps'
   ;plot_contour,indata=quantity,'Test Particles',step,dim=[0,2230,-400,400],/print,bar_low=-90,bar_up=90
   ind1=where(vy ge 0,count1)
   ind2=where(vy lt 0,count2)
   plotsym,0,1,xrange=[0,2230],yrange=[400,400],/fill
                                ;plot,datax[ind1],datay[ind1],psym=8,xrange=[-10,2230],yrange=[-300,300]
   if count1 ne 1 then $
      oplot,datax[ind1],datay[ind1],psym=8
   plotsym,0,1,color=3
   if count2 ne 0 then $
      oplot,datax[ind2],datay[ind2],psym=8,color=!p.color-1
   ;PS_END,/PNG,/delete_ps
endfor

end


PRO PLOT_DISTRIBUTION

;restore,filename='/Users/yanhualiu/Desktop/tparticle.dat'
;data=a.field00001

timestep=84545;146240
n_electron=1L
n_proton=1L
n_oxygen=1L
totalstep=5000L;
data=fltarr((n_electron+n_proton+n_oxygen)*6,totalstep)
OPENR,99,"/net/home/ssc/yhliu/ccat_user/tparticles/data/test"+strtrim(string(timestep),2)+".dat"
READF,99,data
CLOSE,99 
print, "Reding Done"

;opengda,timestep
;product='ue'
;v_dot_b=dot_field(product,'b',timestep)
;absV=abs_quantity(product,timestep)
;absB=get_quantity('absB',timestep)

;asine=asin(v_dot_b/(absV*absB))*180./!pi
;close,/all
;free_lun, 1
!p.charsize=2.
window, xsize=800, ysize=800
;plot_3dbox,[0,2000],[-100,100],[-100,100],psym=1,xtitle='x',ytitle='y',ztitle='z'
;plot_3dbox,[-0.1,0.1],[-0.1,0.1],[-0.1,0.1],psym=1,xtitle='x',ytitle='y',ztitle='z'

plot,[0,2230,0,0],[0,0,-500,500],psym=1,xtitle='x',ytitle='z'

for i=0,2 do begin
   plots,data[i*6,*],data[i*6+2,*],color=i+1;,data[i*6+2,*],/T3D
endfor

stop
plot_dist,data,0,n_electron-1,totalstep,asine,path1
;plot_dist,data,n_electron,n_electron+n_proton-1,totalstep,asine,path2
;plot_dist,data,n_electron+n_proton,n_electron+n_proton+n_oxygen-1,totalstep,asine,path3

stop


END
