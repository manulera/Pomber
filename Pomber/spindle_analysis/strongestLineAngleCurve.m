function [result] = strongestLineAngleCurve(ima,mask,bg,sugg,second_degree)
% sugg(1)=atan(sugg(1));
fun = @(pars) weightFunctionAngleCurve2(ima,mask,bg,pars,second_degree);

opts = optimset('MaxFunEvals',5000, 'MaxIter',1000);

result = fminsearch(fun, sugg, opts);
if ~second_degree
    result(4)=0;
end
end

