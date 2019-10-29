function [ int ] = thicc_profile_old( ima,mask,x,y,dis_thresh )
    if nargin<5
        dis_thresh = 5;
    end
    % x and y are the coordinates of the line on which the points are
    % projected.
    line_points = numel(x);
    int = zeros(1,line_points);
    
    lis = regionprops(mask,ima,'PixelList','PixelValues');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    zz = lis.PixelValues;
    nb_pix = numel(xx);
    
    % Calculate a matrix of distances of the pixels to the 
    all_dis = nan(line_points,nb_pix);
    
    for i = 1:line_points
        all_dis(i,:) = (xx-x(i)).^2 + (yy-y(i)).^2;
    end
    
    % Get the indexes of the minimum distance
    [dis_vals,ind] = min(all_dis,[],1);
    
    for i = 1:nb_pix
        if dis_vals(i)<dis_thresh
            j = ind(i);
            int(j) = int(j) + zz(i);
        end
    end
end

