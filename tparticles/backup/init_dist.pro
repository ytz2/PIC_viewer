PRO INIT_DIST,SPECIE,I0,J0,TINDEX=TIDENX

xmax=2.236068e+03
zmax=2.236068e+03               ;
dx=xmax/64.
dz=zmax/64.
xx=(i0+0.5)*dx
zz=(j0+0.5-32)*dz

if not keyword_set(tindex) then $
   tindex = 146240

;path='/net/nfs/pandora//cluster11/yhliu/oxygen-run1/distributions/data/'
path='/Volumes/Liu/oxygen-run1/distributions/dist'+strtrim(string(tindex),2)+'/'
fln=specie+'particle.'+strtrim(string(tindex),1)+'.dist.'+strtrim(string(i0),1)+'.0.'+strtrim(string(j0),1)+'.bin'

nv=lonarr(3)
vmax=dblarr(3)

openr,unit,path+fln,/get_lun
readu,unit,vmax
readu,unit,nv
dist=dblarr(nv[0],nv[1],nv[2])
readu,unit,dist
close,unit
free_lun, unit

vx = -vmax[0] + 2*vmax[0]/(nv[0]-1)*findgen(nv[0]);
vy = -vmax[1] + 2*vmax[1]/(nv[1]-1)*findgen(nv[1]);
vz = -vmax[2] + 2*vmax[2]/(nv[2]-1)*findgen(nv[2]);


vix=[]
viy=[]
viz=[]
number=[]

for i=0,nv[0]-1 do begin
   for j=0,nv[1]-1 do begin
      for k=0,nv[2]-1 do begin
         if dist[i,j,k] gt 10 then begin
            vix=[vix,vx[i]]
            viy=[viy,vy[j]]
            viz=[viz,vz[k]]
            number=[number,round(dist[i,j,k])]
         endif
      endfor
   endfor
endfor

num=n_elements(vix)

data=fltarr(6,num)
data[0,*]=xx
data[2,*]=zz
data[3,*]=vix
data[4,*]=viy
data[5,*]=viz

openw,lun,'initialization.txt',/get_lun
for i=0,num-1 do begin
   printf,lun,data[*,i]
endfor

free_lun,lun

openw,lun,'initialization_counts.txt',/get_lun
printf,lun,number
free_lun,lun

stop
END
