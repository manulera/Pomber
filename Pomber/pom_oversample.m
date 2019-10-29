function [ x,y ] = pom_oversample( x,y,z )
    % Oversample values with high intensity 
    add1 = z>median(z);
    y2 = y(add1);
    x2 = x(add1);
    z2 = z(add1);
    
    add2 = z2>median(z2);
    y3 = y2(add2);
    x3 = x2(add2);
    z3 = z2(add2);
    y = [y;y3];
    x = [x;x3];
end

