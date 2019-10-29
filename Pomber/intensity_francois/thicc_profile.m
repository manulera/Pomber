function [ int,mask ] = thicc_profile( ima,x,y,dis_thresh )
    if nargin<5
        dis_thresh = 5;
    end
    
    % x and y are the coordinates of the line on which the points are
    % projected.
    line_points = numel(x);
    int = zeros(line_points,1);
    
    % Cut the "tails" of the mask
    
    [~,pos1] = line_indices2(size(ima),[y(1:2),x(1:2)]);
    [~,pos2,off2] = line_indices2(size(ima),[y((end-1):end),x((end-1):end)]);
    
    mask = ~(pos1<0 | pos2>off2(end));
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
    mask = false(size(mask));
    for i = 1:nb_pix
        if dis_vals(i)<(dis_thresh^2) % distances are squared
            j = ind(i);
            mask(yy(i),xx(i))=true;
            int(j) = int(j) + zz(i);
        end
    end
end

