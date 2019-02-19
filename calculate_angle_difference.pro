
;Determine the difference in angle from two tplot variables. 
;For example, on a 24 hr MLT dial plot two BARREL balloons may be at 
;23 MLT and 1 MLT. Just taking the difference we would have 
;deltaMLT = 23 - 1 = 22 hrs, or 
;deltaMLT = 1 - 23 = -22 hrs. 

;The correct answer is 2 hrs. 
;This program gets this correct, thus removing the "jump" in delta-MLT
;values caused by the transition from 24 hrs to 0 hrs. 

;Defaults to MLT, but can set the "deg" or "rad" keywords to 
;use 360 deg or 2*pi instead of 24 hrs. 

;Input tplot quantities must be in the correct angle units b/c no 
;conversions are done. 

;Returns tplot variable with the angle difference. Times are those interpolated 
;to tvar1. 

;Written by Aaron W Breneman, 2018-04-11

pro calculate_angle_difference,tvar1,tvar2,deg=deg,rad=rad,newname=newname


if ~keyword_set(newname) then newname=tvar1+'-'+tvar2
if ~keyword_set(deg) and ~keyword_set(rad) then maxangle = 24.
if keyword_set(deg) then maxangle = 360.
if keyword_set(rad) then maxangle = 2*!pi

;------------------------------
;Interpolate to same time base.
;------------------------------

tinterpol_mxn,tvar2,tvar1,newname=tvar2+'_interptmp',/ignore_nans


get_data,tvar1,data=angle1
get_data,tvar2+'_interptmp',data=angle2


mltgreater = angle1.y > angle2.y
mltlesser = angle1.y < angle2.y

;------------------------------
;Calculate angle difference by going both ways around the dial plot. 
;With the above balloon example this would be 
;(a) 23 - 1 = 22  hrs 
;(b) (24 - 23) + 1 = 2 hrs
;------------------------------

mltdiff1 = mltgreater - mltlesser 
mltdiff2 = (maxangle - mltgreater) + mltlesser

;------------------------------
;We'll take the smaller of these two as the final value. 
;------------------------------

mltdiff = mltdiff1 < mltdiff2

store_data,newname,angle1.x,mltdiff
store_data,tvar2+'_interptmp',/delete

end