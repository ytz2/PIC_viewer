
PRO SAVE_DIST

step=146240
zcut_range=[-30,0]
;restore,filename='/Volumes/Liu/oxygen-run1/o_diffusion'
zmax=2236.07
dz=zmax/64
zrange=floor((zcut_range+zmax/2.)/dz)
j0=zrange[0]+indgen(zrange[1]-zrange[0]+1)
zz=(j0+0.5-32)*dz

opengda,step
;pot=calc_epotential(step)
for i=0,n_elements(j0)-1 do begin
   x_range=[0,2230]
   path= '~/Desktop/'+strtrim(string(step),2)+'/j='+strtrim(string(j0[i]),1)
   spawn,'mkdir '+path
   PS_START,FILENAME=path+'/'+'j='+strtrim(string(j0[i]),1)+'.ps',/landscape
   plot_contour,'by',step,dim=[0,2230,-600,600],/ay,/print ;,bar_low=-0.1,bar_up=0.5
   plot_cut_dist,step,zcut=zz[i],xrange=x_range,/sav,/nostop,path=path+'/'
   PS_END
endfor

END
