function [ b,out ] = crop_cell( mask )
    
    % Do a convex hull if there is more than one region
    [~, numberOfObject] = bwlabel(mask);
    if numberOfObject >1 
        mask = bwconvhull(mask);
    end
    
    % Find major axis, and rotate, also store initial bounding box for
    % plotting in the major axis
    rp_orien = regionprops(mask,'Orientation','BoundingBox');
    b = round(rp_orien.BoundingBox);
    b = [[b(1) b(1)+b(3) b(1)+b(3) b(1) b(1) ]' [b(2) b(2) b(2)+b(4) b(2)+b(4) b(2)]'];
    out.angle = -rp_orien.Orientation;
    out.ori_mask = mask;
    out.rotated_mask = imrotate(mask,out.angle);
    %ori_rot = imrotate(ori,out.angle);
    
    % Rotate the images so that the axis of the cell is parallel 
    exp_box = 10;
    rp_box = regionprops(out.rotated_mask,'BoundingBox');
    box = round(rp_box.BoundingBox);
    box = box + [-exp_box -exp_box 2*exp_box 2*exp_box];
    
    s = size(out.rotated_mask);
    xlims = box(1):(box(1)+box(3));
    ylims = box(2):(box(2)+box(4));
    
    xlims(xlims>s(2)) = [];
    xlims(xlims<1) = [];
    ylims(ylims>s(1)) = [];
    ylims(ylims<1) = [];
    
    out.xlims = xlims;
    out.ylims = ylims;

end

