;+
; NAME:
;      poisson 
;
; PURPOSE:
;       Calculate the electrostatic potential with periodic condition
;       under 2D domain. Implement 2D fft.
; 
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
;       Modified by: Yanhua Liu, May 30, 2013, updated with poisson solver




function poisson, infield,dx

dims = size(infield, /dim)
nx = dims(0)	; define dimensionality
ny = dims(1)

; define arrays
outfield = fltarr(nx,ny)  	; this will be output array
outspect = complexarr(nx,ny) 	; this spectrum w/FFT gives outfield


; define frequency arrays as IDL does -- for even and odd cases
if ((nx)mod(2) eq 0) then xfreqs = $
[0,(findgen(nx/2) + 1)/(nx),-reverse(findgen(nx/2-1) + 1)/(nx)] $
else xfreqs = $
[0,(findgen(nx/2.-.5) + 1)/(nx),-reverse(findgen(nx/2.-.5) + 1)/(nx)]


if ((ny)mod(2) eq 0) then yfreqs = $
[0,(findgen(ny/2) + 1)/(ny),-reverse(findgen(ny/2-1) + 1)/(ny)] $
else yfreqs = $
[0,(findgen(ny/2.-.5) + 1)/(ny),-reverse(findgen(ny/2.-.5) + 1)/(ny)]

inspect = fft(infield, -1)

for i = 0,nx-1 do begin
	for j = 0,ny-1 do begin

		; laplacian of 0-modes is zero, so start w/non-zero modes.
		if ((i ne 0) or (j ne 0)) then $
		outspect(i,j) = -(2*!pi)^(-2)/ $
				((xfreqs(i))^2+(yfreqs(j))^2) $
				*inspect(i,j)

	endfor
endfor

outfield = real_part(fft(outspect,1))*dx^2.

return, outfield

end
