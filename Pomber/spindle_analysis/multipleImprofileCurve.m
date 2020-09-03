function [ints,xx,yy] = multipleImprofileCurve(ima,pars,range,spacing,method)
    
if nargin<5
    method = 'nearest';
end


x = -200:200;
y = x.^2*pars(4);
poly=resamplePolyline([x',y'],round(sum(sqrt(diff(x).^2+diff(y).^2))));


% In this case, we generate parallel parabollas (or lines if pars(4)=0)
disp = -range*spacing:spacing:range*spacing;

nb_vals = size(poly,1);
nb_slices = range*2+1 ;

xx = zeros(nb_slices,nb_vals);
yy = xx;

% Rotate then
theta = -pars(1);
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];


for i = 1:nb_slices
    % Rotate
    coords = [poly(:,1),poly(:,2)+disp(i)]*R;
    % Substract
    xx(i,:) = coords(:,1) + pars(2);
    yy(i,:) = coords(:,2) + pars(3);
end


% The matrix where we will store the values


ints = nan(nb_slices,nb_vals);

% figure
% imshow(ima,[])
% hold on
% plot(x,y)
% uiwait


for i =1:nb_slices
    ints(i,:) = improfile(ima,xx(i,:),yy(i,:),nb_vals,method);
end

end

