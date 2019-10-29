function [kym,bigpass] = custom_improfile_old(ima, points, width)

% function kym = line_kymograph(mov, pts, width)
%
% Build a kymograph around a line defined by 'pts' including all pixels
% within a distance 'width' from the line.
% 
% points: coordinates of points, size(points) = [N, 2] 
% width:  width in pixels
%
% F. Nedelec, Nov. 2017

dim = size(ima);

[dis, pos,offs] = line_indices2(dim, points);

dis = abs(dis);

pos_max = ceil(offs(end));

% Those points which lay within the abscissa range
keep1 = pos<(pos_max + width) & pos> -width;
% Those which are close to the line
keep2 = dis<width;
% keep2 and dis do not change in the different points if its a perfectly
% straight line, but it would change in the case of a curve

% Get the combined masks
keep = keep1&keep2;
if nargout>1
    mask = any(keep,3);
end

pos = pos.*keep;
elems = numel(offs);
% Zero indexing makes +1
kym = zeros(1, pos_max+1);
offs = [0 offs];
bigpass = zeros(size(pos(:,:,1)));
for i = 1:elems
    pass1 = pos(:,:,i)>offs(i) & pos(:,:,i)<offs(i+1);
    pass = find(pass1);
    % Integer value of the abscissa, I do floor+1 in case pos(pass) is
    % zero, this happens often in the lines I have since the x values are
    % initially coming from pixel positions
    absc_int = floor(pos(pass))+1;
    bigpass = pass1+bigpass;
    for j = 1:numel(absc_int)
        kym(absc_int(j)) = kym(absc_int(j)) + ima(pass(j));
    end
end

end

