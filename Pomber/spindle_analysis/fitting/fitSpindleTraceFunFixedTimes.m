function [ out ] = fitSpindleTraceFunFixedTimes( t,data,t1,t2,first_guess )
    
    fun2min = @(par) sum((spindle_trace_fun(t,[t1 t2 par]) - data).^2);
    
    fitpars=fminsearch(fun2min,first_guess);
    
    out = [t1 t2 fitpars];
end

