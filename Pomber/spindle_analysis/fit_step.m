function [pars] = fit_step(data,sugg)
    
    x = 1:numel(data);
    logic = ~isnan(data);
    data = data(logic);
    x = x(logic);
    fun = @(p) nansum(abs(twostepfun(x,p(1),p(2),p(3),p(4),p(5))-data));

    opts = optimset('MaxFunEvals',50000, 'MaxIter',10000);
    if isempty(sugg)
        sugg = [numel(data)/2*0.9+x(1),numel(data)/2*1.1+x(1),quantile(data,0.3),max(data)/2,quantile(data,0.3)];
    end
    pars = fminsearch(fun, sugg, opts);
end

