function [ints,xx,yy] = multiple_improfile(ima,x,y,pfit,range,spacing,method)
    
if nargin<6
    method = 'nearest';
end

% The matrix where we will store the values
nb_vals = numel(x);
nb_slices = range*2+1 ;

ints = nan(nb_slices,nb_vals);

% Perpendicular to the slope of the line from the polyfit
slope = [pfit(1),-1];
slope = slope/norm(slope);

% We calculate perpendicular displacements from the line of value 'spacing'
% from the points at the edges of the line given by x and y

disp = -range*spacing:spacing:range*spacing;

xx = x+disp*slope(1);
xx = xx';
yy = y+disp*slope(2);
yy = yy';

for i =1:nb_slices
    ints(i,:) = improfile(ima,xx(i,:),yy(i,:),nb_vals,method);
end

end

