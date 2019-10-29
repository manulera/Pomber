function [ dis, abs,all_off ] = line_indices( dim, points )

% Calculate signed distance and projected abscissa of the pixels
% 
% Syntax:  [ dis, abs ] = indices_line( dim, points )
%
% Arguments:
%       dim   : size of image ( dim = [height, width] )
%       points: coordinates of points, size(points) = [N, 2] 
%
% Results:
%       dis   : signed distance to the segments
%       abs   : projected abscissa on the line supporting each segment
%
%   dis and abs are of size [dim(1), dim(2), N-1]
%
% The origin of the abscissa is the first point, and it is increased
% for the subsequent segments so as to mimmick a curviliear abscissa
% along the string of points.
%
% Serge Dmitrief and Francois Nedelec, EMBL - Dec. 2012

if nargin < 2
    error('indices_line() requires 2 arguments');
end

if length(dim) ~= 2
    error('First argument should specify 2 dimensions'),
end

if size(points, 2) ~= 2
    error('Second argument should specify 2 coordinates for each point');
end

if size(points, 1) < 2
    error('Second argument should specify at least 2 points');
end

%% Allocation

nbs = size(points, 1) - 1;

dis = zeros(dim(1), dim(2), nbs);
abs = zeros(dim(1), dim(2), nbs);

%% Computation

valY = ones(dim(1), 1) * (1:dim(2));
valX = (1:dim(1))' * ones(1, dim(2));

offs = 0;
all_off = zeros(1,nbs);
% process every segment
for i=1:nbs
    
    pta = points(i,   :);
    ptb = points(i+1, :);
    
    diff = ptb - pta;
    dir  = diff ./ norm(diff);
    
    % projection along the line:
    abs(:,:,i) = ( valX - pta(1) ) * dir(1) + ( valY - pta(2) ) * dir(2) + offs;
    
    % signed distance = orthogonal projection
    dis(:,:,i) = ( valX - pta(1) ) * dir(2) - ( valY - pta(2) ) * dir(1);
    
    % update offset:
    offs = offs + norm(diff);
    all_off(i) = offs;
end

end

