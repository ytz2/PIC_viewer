;CALCUALTE THE DIV of Pressure gradient
; xx xy xz
; yx yy yz
; zx zy zz
; div(pe)x= dxx/dx+dyx/dy+dzx/dz and etc...


FUNCTION DIV_P,STEP,COMPONENT,specie=specie,xcut=xcut,zcut=zcut,smth=smth
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory


if not keyword_set(specie) then specie='e'

if component eq 'x' then begin
   p1='p'+specie+'-xx'
   p2='p'+specie+'-xy'
   p3='p'+specie+'-xz'
   dx=xmax/nx
endif

if component eq 'y' then begin
   p1='p'+specie+'-xy'
   p2='p'+specie+'-yy'
   p3='p'+specie+'-yz'
endif

if component eq 'z' then begin
   p1='p'+specie+'-xz'
   p2='p'+specie+'-yz'
   p3='p'+specie+'-zz'
   dx=zmax/nz
endif

p1_data=get_quantity(p1,step)
p2_data=get_quantity(p2,step)
p3_data=get_quantity(p3,step)



dat=finite_diff(p1_data, /x)+finite_diff(p3_data, /z)

if keyword_set(smth) then dat=smooth(dat,smth)

if arg_present(xcut) then dat=map_data(data=dat,xcut=xcut)
if arg_present(zcut) then dat=map_data(data=dat,zcut=zcut)

return,dat

END
