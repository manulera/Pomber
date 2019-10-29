function [y] = spindle_trace_fun(t,pars)
    t1 = pars(1);
    t2 = pars(2);
    t3 = pars(3);
    s1 = pars(4);
    s2 = pars(5);
    s3 = pars(6);
    offset = pars(7);
    y = nan(size(t));
    
    % The three parts of the function
    first = t<t1;
    y(first) = offset + s1.*t(first);
    
    second = t>=t1 & t<t2;
    y(second) = offset + s1 .* t1 + s2.*(t(second)-t1);
    
    third = t>=t2;
    y(third) = offset + s1 * t1 + s2 .* (t2-t1) + s3 .*(t(third)-t2);
    
%     forth = t>t3;
%     y(forth) = offset + s1 * t1 + s2 * t2 + s3*t3;
end

