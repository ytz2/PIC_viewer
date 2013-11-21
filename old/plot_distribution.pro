
PRO PLOT_DIST, data,starts,ends,totalstep,waittime

for step=0,totalstep-1 do begin
   datax=[]
   datay=[]
   vy=[]
   for i=starts,ends do begin
      datax=[datax,data[i*6,step]]
      datay=[datay,data[i*6+2,step]]
      vy=[vy,data[i*6+4,step]]
   endfor
   ind1=where(vy ge 0)
   ind2=where(vy lt 0,count2)
   plotsym,0,1
                                ;plot,datax[ind1],datay[ind1],psym=8,xrange=[-10,2230],yrange=[-300,300]
   oplot,datax[ind1],datay[ind1],psym=8
   plotsym,0,1,color=3
   if count2 ne 0 then $
      oplot,datax[ind2],datay[ind2],psym=8,color=!p.color-1
   wait,waittime
endfor

end


PRO PLOT_DISTRIBUTION

;restore,filename='/Users/yanhualiu/Desktop/tparticle.dat'
;data=a.field00001
timestep=145783
n_electron=2000L
n_proton=2000L
n_oxygen=2000L
totalstep=1000L;
data=fltarr((n_electron+n_proton+n_oxygen)*6,totalstep)
OPENR,99,'/Users/yanhualiu/Desktop/test5.dat'
READF,99,data
CLOSE,99 
print, "Reding Done"
device, decomposed = 0
device, retain = 2
waittime=0.01
stop
;window,!D.WINDOW +1,xsize=1200,ysize=800
;loadct2,33

opengda,timestep
plot_contour,'by',timestep,dim=[0,2230,-500,500],/ay
stop
plot_dist,data,0,n_electron-1,totalstep,waittime
stop
plot_dist,data,n_electron,n_electron+n_proton-1,totalstep,waittime
stop
plot_dist,data,n_electron+n_proton,n_electron+n_proton+n_oxygen-1,totalstep,waittime
stop


END
