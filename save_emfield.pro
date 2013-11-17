
; save the averaged local magnetic field & electric field to file
; the sequence is upto define

FUNCTION GET_LOCAL_MEAN,FULLDATA,dim
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

imin=fix(dim[0]/xmax*nx)
imax=fix(dim[1]/xmax*nx)-1
lx = imax-imin +1 
jmin = fix((1.0+dim[2]/zcenter)*nz/2)
jmax = nz-1-fix((1.0-dim[3]/zcenter)*nz/2)
lz = jmax-jmin +1 
return,mean(fulldata(imin:imax,jmin:jmax))
END




PRO SAVE_EMFIELD,step
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

opengda,step

bx=get_quantity('bx',step)
by=get_quantity('by',step)
bz=get_quantity('bz',step)
ex=get_quantity('ex',step)
ey=get_quantity('ey',step)
ez=get_quantity('ez',step)  

xdim=scale_vector(findgen(65),0,xmax)
zdim=scale_vector(findgen(65),-zcenter,zcenter)

openw,99,'em_block_'+strtrim(string(step),1)+'.txt'
for j=0,63 do begin
   for i=0,63 do begin
      range=[xdim[i],xdim[i+1],zdim[j],zdim[j+1]]
      avbx=get_local_mean(bx,range)
      avby=get_local_mean(by,range)
      avbz=get_local_mean(bz,range)
      avex=get_local_mean(ex,range)
      avey=get_local_mean(ey,range)
      avez=get_local_mean(ez,range)
      printf,99,avbx,avby,avbz,avex,avey,avez
   endfor
endfor
close,99
stop
END
