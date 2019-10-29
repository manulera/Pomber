function kym = line_kymograph(mov, points, width)

% function kym = line_kymograph(mov, pts, width)
%
% Build a kymograph around a line defined by 'pts' including all pixels
% within a distance 'width' from the line.
% 
% points: coordinates of points, size(points) = [N, 2] 
% width:  width in pixels
%
% F. Nedelec, Nov. 2017

n_img = length(mov);
dim = size(mov(1).data);

if any( size(points) ~= [2, 2] )
    error('Second argument should specify 2 points'),
end

[dis, pos] = line_indices(dim, points);

dis = abs(dis);

pos_min = floor(min(min(pos)));
pos_max = ceil(max(max(pos)));
width = width / 2;

kym = zeros(n_img, pos_max);

for i = 1 : n_img
       
    data = mov(i).data;
    if any( dim ~= size(data) )
        error('image size missmatch in movie');
    end

    for v = pos_min:pos_max
        pass = ( v <= pos ) .* ( pos < v+1 ) .* ( dis <= width );
        kym(i, v) = mean(data(logical(pass)));
    end
        
end

end
