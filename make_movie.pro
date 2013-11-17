PRO MAKE_MOVIE,step
  
j=31


dx=2236.07/64
xx=(findgen(64)+0.5)*dx
zz=(findgen(64)+0.5-32)*dx
opengda,step
restore,filename='/Volumes/Liu/oxygen-run1/o_diffusion'


for i=0,63 do begin

   ps_start,filename='slice_'+string(i,format='(I03)'),/landscape
   plot_contour,'O DR',step,indata=o_diffusion,bar_low=-0.1,bar_up=0.5,dim=[0,2230,-500,500],/print
   plotsym,8,2.5,color=1,/fill
   oplot,[xx[i]],[zz[j]],psym=8
   ps_end,/png,/delete_ps
endfor

END
