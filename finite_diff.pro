;+
; NAME:
;      finite_diff
;
; PURPOSE:
;       Calculate the finite difference in x,z direction
; 
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       finite_diff,product,step,/x( or /z)
;
; INPUTS:
;       step: time step
;       product: scalar name
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), April, 2013
;       Nov 12,2013, give up the convolution method and replace with
;       shift method

FUNCTION finite_DIFF,image,x=x,z=z,y=y
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory

;------------------------------------------
;prepare
;------------------------------------------
;isize = size(data,/dimensions)
;ncol = isize[0]
;nrow = isize[1]

;filter = double([ [-1,-2,-3,-2,-1], [0,0,0,0,0], [1,2,3,2,1] ])
;if keyword_set(x) then begin
;   newdata=convol(data,transpose(filter),/center,/edge_truncate)
;endif

;if keyword_set(z) then begin
;   newdata=convol(data,filter,/center,/edge_truncate)
;endif

;return,newdata

; get the size of 2D image
sim=size(image)

; df(x)/dx=(f(x+h)-f(x))/h
if keyword_set(x) then begin
   delta=1./(xmax/nx) ;  calculate h
   didx = ( shift( image, -1,  0 ) - shift( image, 1, 0 ) ) ; shift h=1
   didx(0,*) = image(1,*) - image(0,*) ; calculate the f(x+h)-f(x)
   didx(sim(1)-1,*) = image(sim(1)-1,*) - image(sim(1)-2,*) ; corner 
endif

if keyword_set(z) then begin
   delta=1./(zmax/nz)
   didx = ( shift( image,  0, -1 ) - shift( image, 0, 1 ) ) 
   didx(*,0) = image(*,1) - image(*,0)
   didx(*,sim(2)-1) = image(*,sim(2)-1) - image(*,sim(2)-2)
endif
if keyword_set(y) then return,0
return, didx*delta ; df(x)/dx=(f(x+h)-f(x))/h

END
