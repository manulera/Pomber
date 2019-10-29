function [out] = twostepfun(x,x1,x2,y1,y2,y3)
out = zeros(size(x));
out(x<x1)=y1;

out(x<x2&x>=x1)=y2;
out(x>=x2)=y3;
    
end

