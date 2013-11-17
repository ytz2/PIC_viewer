FUNCTION CALC_DIFFUSION,product,step

vx=velocity_perp(product,'x',step)
vy=velocity_perp(product,'y',step)
vz=velocity_perp(product,'z',step)
btot=(get_quantity('absB',step))^2
ecrossbx=cross_field('e','b','x',step)/btot
ecrossby=cross_field('e','b','y',step)/btot
ecrossbz=cross_field('e','b','z',step)/btot
e_diffusion=sqrt((vx-ecrossbx)^2.+(vy-ecrossby)^2.+(vz-ecrossbz)^2.)

stop
return, e_diffusion

END
