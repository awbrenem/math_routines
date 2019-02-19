;Transform GSE coordinates to aberrated GSE coordinates. 
;Written by Aaron W Breneman, Feb 19, 2019...forked from 
;Lynn Wilson's code. 
;Uses Lynn's eulermat.pro

pro rotate_gse2aberratedgse,gsecoord,vsw


    ;Velocity of Earth around sun (km/s)
    v_e = 29.78
    ;;Solar wind velocity 
    ;vsw = 400.


    abber  = ATAN(v_e[0]/vsw[0])                     ; => abberation correction [radians]
    ; => rotation from GSE to abberated system
    abrot  = TRANSPOSE(eulermat(0d0,abber[0],0d0,/RAD))
    ; => rotation from abberated to GSE system
    iabrot = TRANSPOSE(abrot)


    vgse = [10.,0,0]
    vagse = reform(vgse ## abrot)

    ;Test inverse transform
    vgse2 = vagse ## iabrot

end