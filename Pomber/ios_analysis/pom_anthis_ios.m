function [ c ] = pom_anthis_ios( c,channel,i,im_bg_all,given_edges )
    if nargin<5
        given_edges = false;
    end
    s = c.sp.spind{i};
    if ~isempty(s)
        im_bg = im_bg_all(i);
        ima = c.video{channel}(:,:,i)-im_bg;
        
        [ c.ios.int{i},c.ios.tot_int(i),c.ios.r_int(i),c.ios.bg(i) ] = ...
            intensity_on_spindle( ima,s,c.masks(:,:,i));
        
        if ~given_edges
            c.ios.edges(:,i) = find_ios_edges(c.ios.int{i});
        end
        
        [ c.ios.int2{i},c.ios.tot_int2(i),c.ios.r_int2(i)] = ...
            intensity_on_spindle( ima,s,c.masks(:,:,i),c.ios.edges(:,i));
        % They have to be column vectors
        c.ios.int{i} = c.ios.int{i}(:);
        % They have to be column vectors
        c.ios.int2{i} = c.ios.int2{i}(:);
    else
        c.ios.int{i} = 0;
        c.ios.int2{i} = 0;
    end
    
end