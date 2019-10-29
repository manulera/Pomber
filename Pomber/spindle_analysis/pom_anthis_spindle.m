% unused
function [ c ] = pom_anthis_spindle( c,channel,t,resolution,im_bg )
    
    i = find(c.list==t);
    ima = c.video{channel}(:,:,i).*c.masks(:,:,i);
    % [c.sp.spind{i},c.sp.mask(:,:,i),c.sp.cont{i}]=draw_spindle(ima,resolution,c.sp.mask(:,:,i),c.sp.cont{i});
    [c.sp.spind{i}]=draw_spindle(ima,resolution,c.sp.spind{i});    
    c = pom_postspindle(c,channel,im_bg);

end

