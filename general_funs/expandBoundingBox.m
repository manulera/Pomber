function [x_box,y_box] = expandBoundingBox(mask,box_expansion)
    
    % Using region props, take the bounding box and expand it by
    % box_expansion/2 times the x and y size of the box in those
    % directions.
    
    rp = regionprops(mask);
    
    x_min = round(rp.Centroid(1)-rp.BoundingBox(3)*box_expansion);
    x_max = round(rp.Centroid(1)+rp.BoundingBox(3)*box_expansion);
    % The resulting mask should not come out of the original image:
    if x_min<1
        x_min=1;
    end
    if x_max>size(mask,2)
        x_max = size(mask,2);
    end

    y_min = round(rp.Centroid(2)-rp.BoundingBox(4)*box_expansion);
    y_max = round(rp.Centroid(2)+rp.BoundingBox(4)*box_expansion);
    % The resulting mask should not come out of the original image:
    if y_min<1
        y_min=1;
    end
    if y_max>size(mask,1)
        y_max = size(mask,1);
    end
    
    x_box = x_min:x_max;
    y_box = y_min:y_max;
    
    
end

