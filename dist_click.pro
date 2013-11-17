PRO DIST_CLICK,STEP
  opengda,step

  ;plot_contour,'|ue|',step,indata=e_diffusion,bar_low=-0.1,bar_up=0.5
  ;stop
  ;plot_contour,'|ui|',step,indata=h_diffusion,dim=[0,2230,-500,500],bar_low=-0.1,bar_up=0.5
  ;plot_contour,'|uo|',step,indata=o_diffusion,dim=[0,2230,-500,500],bar_low=-0.1,bar_up=0.5
  ;stop
  ;PLOT_PATTERN,'i',step,dim=[0,2230,-500,500],smth=8,grid=[80,40],length=0.03
  ;stop

  restore,filename='/Volumes/Liu/oxygen-run1/h_diffusion'
  plot_contour,'|ui|',step,indata=h_diffusion,dim=[0,2230,-500,500],bar_low=-0.1,bar_up=0.5
  ;plot_contour,'by',step,dim=[0,2230,-500,500],/ay
  WHILE(!MOUSE.BUTTON NE 4) DO BEGIN
     print, 'Left click to select region'
     print, 'Right click to select region'
     CURSOR,X,Y,WAIT,/down
     PLOT_CUT_DIST,step,xcut=x,zcut=y,/nostop  
  endwhile 

END
