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

; SIDE EFFECTS:
;       no matter how small the domain is, it always load the whole dataset
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu)

FUNCTION AGYROTROPY,SPECIE,STEP

;-----------------------------------------
; Prepare for quantities
;-----------------------------------------
bx= GAUSS_SMOOTH(get_quantity('bx',step),5)
by= GAUSS_SMOOTH(get_quantity('by',step),5)
bz= GAUSS_SMOOTH(get_quantity('bz',step),5)
pxx= GAUSS_SMOOTH(get_quantity('p'+specie+'-xx',step),5)
pxy= GAUSS_SMOOTH(get_quantity('p'+specie+'-xy',step),5)
pxz= GAUSS_SMOOTH(get_quantity('p'+specie+'-xz',step),5)
pyy= GAUSS_SMOOTH(get_quantity('p'+specie+'-yy',step),5)
pyz= GAUSS_SMOOTH(get_quantity('p'+specie+'-yz',step),5)
pzz= GAUSS_SMOOTH(get_quantity('p'+specie+'-zz',step),5)
pyx=pxy  ;get_quantity('p'+specie+'-yx',step)
pzx=pxz  ;get_quantity('p'+specie+'-zx',step)
pzy=pyz  ;get_quantity('p'+specie+'-zy',step)
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

return,A
END
