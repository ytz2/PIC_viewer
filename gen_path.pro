
;+
; NAME:
;       GEN_PATH
;
; PURPOSE:
;       Return the location (x,y) in unit of de and index in 2D array
;       with (ix,iy)
; EXPLANATION:
;       Work together with orbit_click to generate any cut defined by user
;
; CATEGORY:
;       Utitlity
;
; CALLING SEQUENCE:
;       result=gen_path(X,Z,scale)
;
; INPUTS:
;       X: 1d array
;       Y: 1d array
;       scale: scalar, seperation between points
;
; MODIFICATION HISTORY:
;       Written by:  Yanhua Liu (yhliu@atlas.sr.unh.edu), Oct 2012.



FUNCTION POS2INDEX,X,Z
; accept two double value to convert to the index in the 2d data
; this requires the simulation info
common parameters,nx,nz,tslices,xmax,zmax,zcenter,numq,tindices,directory
zcenter=zmax/2.0
return,[X/xmax*nx,(1.0+Z/zcenter)*nz/2 ]
END




;accept (x0,y0),(x1,y1), default seperation of the vector is 1
;return a group of vectors between this two points
;required dfanning software package and POS2INDEX(X,Z)

FUNCTION GEN_P2P_PATH, x0,y0,x1,y1,scale

num=fix(norm([x1-x0,y1-y0])/scale)
xx=scale_vector(findgen(num),x0,x1)
yy=scale_vector(findgen(num),y0,y1)
n0=pos2index(x0,y0)
n1=pos2index(x1,y1)
nxx=scale_vector(findgen(num),n0[0],n1[0])
nyy=scale_vector(findgen(num),n0[1],n1[1])
return, {x:xx,z:yy,nx:nxx,nz:nyy}
END


; accept two vector X, Z and then convert it to path 
;vectors and index vectors,default scale is 1.
FUNCTION GEN_PATH,X,Z,scale
path_x=[] & path_z=[] & index_x=[] & index_z=[]

for i=0, n_elements(X)-2 do begin
   local_data=gen_p2p_path(x[i],z[i],x[i+1],z[i+1],scale)
   path_x=[path_x,local_data.x]
   path_z=[path_z,local_data.z]
   index_x=[index_x,local_data.nx]
   index_z=[index_z,local_data.nz]
endfor
return, {x:path_x,z:path_z,nx:index_x,nz:index_z}
END

