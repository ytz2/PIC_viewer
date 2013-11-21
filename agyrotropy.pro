; NAME:
;      Agyrotropy
;
; PURPOSE:
;       Calculate the agyrotropy index
; Reference Scutter et al., 2008 JGR
; "Illuminating" electron diffusion regions of collisionless magnetic
;  reconnection using electron agyrotropy " Appendix A
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       finite_diff,specie,step
; IPUT: specie: e,i,o
;       step: time step
;       smth: gaussian filter number (opitonal), if not set, no filter
;       ave:  use the time-averaged data to calculate
; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu)

FUNCTION AGYROTROPY,SPECIE,STEP,smth=smth,fsmth=fsmth,ave=ave,

aver=''
if keyword_set(ave) then aver='-ave'
;-----------------------------------------
; Prepare for quantities
;-----------------------------------------
bx=get_quantity('bx'+aver,step)
by=get_quantity('by'+aver,step)
bz=get_quantity('bz'+aver,step)
pxx=get_quantity('p'+specie+'-xx'+aver,step)
pxy=get_quantity('p'+specie+'-xy'+aver,step)
pxz=get_quantity('p'+specie+'-xz'+aver,step)
pyy=get_quantity('p'+specie+'-yy'+aver,step)
pzz=get_quantity('p'+specie+'-zz'+aver,step)
pyz=get_quantity('p'+specie+'-yz'+aver,step)
if keyword_set(smth) then begin
   bx= GAUSS_SMOOTH(bx,smth,/nan)
   by= GAUSS_SMOOTH(by,smth,/nan)
   bz= GAUSS_SMOOTH(bz,smth,/nan)
   pxx= GAUSS_SMOOTH(pxx,smth,/nan)
   pxy= GAUSS_SMOOTH(pxy,smth,/nan)
   pxz= GAUSS_SMOOTH(pxz,smth,/nan)
   pyy= GAUSS_SMOOTH(pyy,smth,/nan)
   pyz= GAUSS_SMOOTH(pyz,smth,/nan)
   pzz= GAUSS_SMOOTH(pzz,smth,/nan)
endif

;symetirc tensors
pyx=pxy 
pzx=pxz 
pzy=pyz 
;-----------------------------------------
; Scutter 2008 A2
;-----------------------------------------
nxx=by*by*pzz-by*bz*pyz-bz*by*pzy+bz*bz*pyy
nxy=-by*bx*Pzz+by*bz*Pzx+bz*bx*Pyz-bz*bz*Pyx
nxz=by*bx*Pzy-by*by*Pzx-bz*bx*Pyy+bz*by*Pyx
nyy=bx*bx*Pzz-bx*bz*Pzx-bz*bx*Pxz+bz*bz*Pxx
nyz=-bx*bx*Pzy+ bx*by*Pzx+ bz*bx*Pxy-bz*by*Pxx
nzz=bx*bx*Pyy-bx*by*Pyx-by*bx*Pxy+by*by*Pxx
;-----------------------------------------
; Scutter 2008 A3C
;-----------------------------------------
alpha=nxx+nyy+nzz
beta=-(nxy^2+nxz^2+nyz^2-nxx*nyy-nxx*nzz-nyy*nzz)

;-----------------------------------------
; Scutter 2008 A5
;-----------------------------------------
A=2.*sqrt(alpha^2-4*beta)/alpha

if keyword_set(fsmth) then $
   A=gauss_smooth(A,fsmth,/nan)

return,A
END
