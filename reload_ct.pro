PRO RELOAD_CT

   nc=256
   rgb=fltarr(3,nc)
   usecolor=fltarr(3,nc)
   red=fltarr(nc)
   blue=fltarr(nc)
   green=fltarr(nc)
   CD,C=C
   openr, unit, C+'/Color_Tables/c5.tbl', /get_lun
;openr, unit, '~/Color_Tables/color.tbl', /get_lun
   readf, unit, rgb
   close, unit
   free_lun, unit
   red=rgb(0,*)
   green=rgb(1,*)
   blue=rgb(2,*)
   tvlct,red,green,blue

END
