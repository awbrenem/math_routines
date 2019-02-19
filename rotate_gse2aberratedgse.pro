;Transform GSE coordinates to aberrated GSE coordinates.
;Written by Aaron W Breneman, Feb 19, 2019...forked from
;Lynn Wilson's code.
;Uses Lynn's eulermat.pro

;Input: gsecoord --> vector (or array) of GSE x,y,z coordinates
;       vsw --> single value (or array) of solar wind velocity (km/s)

function rotate_gse2aberratedgse,gsecoord,vsw


    ;Velocity of Earth around sun (km/s)
    v_e = 29.78
    ;;Solar wind velocity

    ;***TEST INPUT
;    vsw = replicate(400.,10)
;    vgse = replicate(0,10,3)
;    for i=0,9 do vgse[i,*] = [10.,0,0]
    ;***

    abber  = ATAN(v_e[0]/vsw[0])                     ; => abberation correction [radians]
    ; => rotation from GSE to abberated system
    abrot  = TRANSPOSE(eulermat(0d0,abber[0],0d0,/RAD))

    return,reform(gsecoord # abrot)


    ;Test inverse transform
    ; => rotation from abberated to GSE system
;    iabrot = TRANSPOSE(abrot)
;    vgse2 = vagse ## iabrot

end
