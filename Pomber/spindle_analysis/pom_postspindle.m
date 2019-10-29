function [ c ] = pom_postspindle( obj,c,channel,im_bg_all)
% Operations to do once the spindle is found
times = numel(c.list);
% Length of the spindle
c.sp.len = zeros(1,times);
% Distance between the poles, could be used compared with the length to get
% the buckling
c.sp.dist = zeros(1,times);
% Intensity of tubulin along the spindle (Intensity profile)
c.sp.int = cell(1,times);
% Ratio of intensity on the spindle vs. intensity of the cytoplasm
c.sp.r_spindle = zeros(1,times);
c.sp.tot_int = zeros(1,times);
% Cell background
c.sp.bg = zeros(1,times);

for i = 1:times
    
    s = c.sp.spind{i};
    % In case you get a very small spindle, you could get its length 0
    if ~isempty(s)
        im_bg = im_bg_all(i);
        c.sp.dist(i) = sqrt(sum((s(1,:)-s(end,:)).^2));
        c.sp.len(i) = sum(sqrt(sum(diff(s).^2,2)));
        c.sp.spind{i} = resamplePolyline(c.sp.spind{i},ceil(c.sp.len(i)));
        ima = c.video{channel}(:,:,i)-im_bg;
        
        [ c.sp.int{i},c.sp.tot_int(i),c.sp.r_spindle(i),c.sp.bg(i) ] = ...
            intensity_on_spindle( ima,s,c.masks(:,:,i));
    else
        c.sp.int{i} = 0;
    end
end

end

