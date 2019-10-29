function [ xx,yy ] = make_elipse( x,y,e,npoints )
% Make an elipse, x and y coordinates of the extremes, and e excentricity

x1 = x(1);
x2 = x(2);
y1 = y(1);
y2 = y(2);

a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
b = a*sqrt(1-e^2);
t = linspace(0,2*pi,npoints);
X = a*cos(t);
Y = b*sin(t);
w = atan2(y2-y1,x2-x1);
xx = (x1+x2)/2 + X*cos(w) - Y*sin(w);
yy = (y1+y2)/2 + X*sin(w) + Y*cos(w);

end

