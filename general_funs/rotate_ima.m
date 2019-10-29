function [ ori_rot,contour ] = rotate_ima( ori,angle,mask,xlims,ylims )

    ori_rot = imrotate(ori,angle);
    ori_rot = ori_rot(ylims,xlims);
    if nargout>1
        mask2 = mask(ylims,xlims);
        contour = bwboundaries(mask2);
        contour = contour{1};
    end
end