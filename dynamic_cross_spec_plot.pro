;Calls dynamic_cross_spec_tplot.pro for two tplot variables. 
;Nicely formats the y and z axes for wave periods. 


pro dynamic_cross_spec_plot,var1,var2,$
    window_minutes=window_minutes,$
    lag_factor=lag_factor,$
    coherence_multiplier=coherence_multiplier,$
    periodmin=periodmin,$
    mincc=mincc


    if ~keyword_set(window_minutes) then window_minutes = 70.
    if ~keyword_set(lag_factor) then lag_factor = 8.
    ;    coherence_multiplier = 2.5
    if ~keyword_set(coherence_multiplier) then coherence_multiplier = 1.5
    if ~keyword_set(periodmin) then periodmin = 1.
    if ~keyword_set(mincc) then mincc = 0.6


    window = 60.*window_minutes   ;seconds
    lag = window/lag_factor
    coherence_time = window*coherence_multiplier



    get_data,var1,data=ttmp
    times1 = ttmp.x
    get_data,var2,data=ttmp
    times2 = ttmp.x


    T1 = times1[0] > times2[0]
    T2 = times1[n_elements(times1)-1] < times2[n_elements(times2)-1]
    timespan,T1,(T2-T1),/seconds



    ;Interpolate to common timebase
    tinterpol_mxn,var2,var1
    v1 = tsample(var1,[T1,T2],times=tms1)
    v2 = tsample(var2+'_interp',[T1,T2],times=tms2)
;    v2 = tsample(var2+'_interp',[t0z,t1z],times=tms2)

    goo1 = where(finite(v1) ne 0.) & goo2 = where(finite(v2) ne 0.)
    store_data,'var1',tms1[goo1],v1[goo1] & store_data,'var2',tms1[goo2],v2[goo2]



    dynamic_cross_spec_tplot,var1,0,var2,0,T1,T2,window,lag,coherence_time,$
            new_name='Precip'

    copy_data,'Precip_coherence','coh_'+var1+'_'+var2
    copy_data,'Precip_phase','phase_'+var1+'_'+var2
    get_data,'coh_'+var1+'_'+var2,data=d
    get_data,'phase_'+var1+'_'+var2,data=dd

    goo = where(d.y lt mincc) & if goo[0] ne -1 then dd.y[goo] = !values.f_nan
    store_data,'phase_'+var1+'_'+var2,data=dd

    periods = 1/d.v/60. & goodperiods = where(periods gt periodmin)

    ;Set NaN values to a really low coherence value
    goo = where(finite(d.y) eq 0) & if goo[0] ne -1 then d.y[goo] = 0.1


    store_data,['Precip_coherence','dynamic_FFT_?','Precip_phase'],/delete


    ;Store coherence data so that it plots in a nice way
    store_data,'coh_'+var1+'_'+var2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'coh_'+var1+'_'+var2,'spec',1
    options,'coh_'+var1+'_'+var2,'ytitle','Coherence!C'+var1+'!C'+var2+'!C[Period (min)]'
    get_data,'phase_'+var1+'_'+var2,data=d
    store_data,'phase_'+var1+'_'+var2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'phase_'+var1+'_'+var2,'spec',1
    options,'phase_'+var1+'_'+var2,'ytitle','Phase!C'+var1+'!C'+var2+'!C[Period (min)]'
    ylim,['coh_'+var1+'_'+var2,'phase_'+var1+'_'+var2],5,40,1
    zlim,'phase_'+var1+'_'+var2,-180,180,0 & zlim,'coh_'+var1+'_'+var2,0.4,1,0

end
