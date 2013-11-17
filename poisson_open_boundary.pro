;+
; NAME:
;      poisson_open_boundary 
;
; PURPOSE:
;       Calculate the electrostatic potential with 
;       periodic condition in z direction and open
;       boundary in x direction
; Reference:
;       Birdsall and Langdon, Plasma Physics via Computer simulation
;       Chapter 14-6 "Possion's equation solutions for system open in x and periodic in y"
;
; CATEGORY:
;       Calculation
;
; CALLING SEQUENCE:
;       result=poisson(charge density,grid size)
;
; INPUTS:
;       step: time step
;     
;       created by: Yanhua Liu, May 23, 2013, updated with poisson solver




FUNCTION POISSON_OPEN_BOUNDARY,charge,nx,ny,lx,ly,boundary=boundary

; FFT of charge density in z direction equation (1)
rhok=complexarr(nx,ny)

for i=0,nx-1 do begin
   rhok[i,*]=IMAGINARY(ly*fft(charge[i,*],-1))
endfor

;calculate rm and dm eq (3) and (5)

if ((ny)mod(2) eq 0) then m = $
[0,(findgen(ny/2) + 1)/(ny),-reverse(findgen(ny/2-1) + 1)/(ny)] $
else m = $
[0,(findgen(ny/2.-.5) + 1)/(ny),-reverse(findgen(ny/2.-.5) + 1)/(ny)]

m=ny*m ; hmmm, I should use the physical fourier component

dm=1.+2.*((lx*ny)/(nx*ly)*sin(!pi*m/(ny-1)))^2
rm=dm+sqrt(dm^2-1)

;implement eq (11) and (12)
;initial condition for psi at nx
psi_xm=complexarr(ny)
psi_xm[*]=complex(0.,0.)
psi=complexarr(nx,ny)
psi[nx-1,*]=psi_xm
for mm=0,ny-1,1 do begin
   for jj=nx-2,0,-1 do begin
      psi[jj,mm]=(psi[jj+1,mm]+rhok[jj,mm])/rm[mm]
   endfor
endfor


; if the left open boundary condition is not set, use 0
if not keyword_set(boundary) then begin
   boundary=complexarr(ny)
   boundary[*]=complex(0.,0.)
endif

phik=complexarr(nx,ny)
phik[0,*]=boundary

; implement eq (17)
for jj=1,nx-1 do begin
   phik[jj,*]=psi[jj,*]+phik[jj-1,*]/rm[*]
endfor

;implement eq (18)
return, ny/ly*real_part(fft(phik,1))

END
