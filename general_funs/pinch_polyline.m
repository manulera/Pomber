function [ coords ] = pinch_polyline( coords, keep,len_thresh ,dist_thresh)

    % Given a certain polyline, if there is a neck point, divide the polyline
    % into several ones
    
    % we are comparing squared distances
    dist_thresh = dist_thresh^2;
    elem = size(coords,1);
    dims = size(coords,2);

    % function for circular indexing
    wrapN = @(x, n) (1 + mod(x-1, n));
    
    mat = nan(elem,elem-2*len_thresh,dims);
    for j = 1:dims
        for i = 1:elem
            ind = wrapN((i+len_thresh):(i+elem-len_thresh-1),elem);            
            mat(i,:,j) = coords(ind,j)-coords(i,j);
        end
    end
    % We need to look by lines, so that the first element we find has
    % the smallest index (every line corresponds to a different
    % point of the coordinates, so if we want the first finding to
    % always have the smallest index, we need to check the min by line)
    dists = sum(mat.^2,3)';
    % We do this until there is nothing to pinch
    if any(dists(:)<dist_thresh)
       
        [~,ind] = min(dists(:));
        
        [pinch2,pinch1] = ind2sub(size(dists),ind);
        % Because we had omitted the next min_dist values, and  because pinch2 is
        % counted from pinch1
        pinch2 = pinch2 + len_thresh + pinch1;
        pinch2 = wrapN(pinch2,elem);
        % Now we have two polygons, we check wether the point "keep" is in
        % each of them, we should keep the one with the point in it
        % No wrapping because in principle pinch1 should be smaller than pinch2
        test = inpolygon(keep(1),keep(2),coords(pinch1:pinch2,1),coords(pinch1:pinch2,2));
        if test
            coords = coords(pinch1:pinch2,:);
        else
            coords = coords(wrapN(pinch2:(pinch1+elem-1),elem),:);
        end
        
        % Run again until the final pinching!
        coords = pinch_polyline( coords, keep, len_thresh,dist_thresh);
    end
end

