function [result] = OLSfit(x,data,f,start_vals,mode)
    if nargin<5
        mode = 'Square';
    end
    switch mode
        case 'Square'
            OLS = @(args) sum((f(x,args) - data).^2);          % Ordinary Least Squares cost function
        case 'Robust'
            OLS = @(args) sum(abs(f(x,args) - data));          % Ordinary Least Squares cost function
    end
    
    opts = optimset('MaxFunEvals',50000, 'MaxIter',10000);

    result = fminsearch(OLS, start_vals, opts); % Use ?fminsearch? to minimise the ?OLS? function
end

