function [ c ] = pom_anint( c,channel,im_bg,repeat )
    % This can only run if there has been a previous analysis of the
    % spindle
    if nargin<4
        repeat = false;
    end
    % For correction
    sizes = size(c.video{channel});
    rows = 6;
    cols = ceil(sizes(3)/rows);
    big_ima = zeros(rows*sizes(1),cols*sizes(2));
    
if any(c.an_type==3)
    times = numel(c.list);
    if ~repeat
        % Initialize variables
        c.an_type(channel) = 4;
        c.ios.int = cell(1,times);
        c.ios.bg = nan(1,times);
        c.ios.r_int = nan(1,times);
        c.ios.tot_int = nan(1,times);
        c.ios.edges = nan(2,times);
        c.ios.tot_int2 = nan(1,times);
        c.ios.r_int2 = nan(1,times);
        c.ios.int2 = cell(1,times);
        % Find the edges and measure
        for i = 1:times
            c = pom_anthis_ios(c,channel,i,im_bg);
        end

    elseif repeat ==2
        for i = 1:times
            c = pom_anthis_ios(c,channel,i,im_bg,true);
        end
        return
    end
    for i = 1:times
        % Compose the big image
        ima = c.video{channel}(:,:,i);
        ima = ima.*c.masks(:,:,i);
        [ro,co] = ind2sub([rows,cols],i);
        xlims = ((ro-1)*sizes(1)+1):(ro*sizes(1));
        ylims = ((co-1)*sizes(2)+1):(co*sizes(2));
        big_ima(xlims,ylims) = ima;
    end
    % Show the big image for correction
    figure
    imshow(big_ima,[],'InitialMagnification','fit')
    title('Select the wrong ios and click enter')
    hold on
    pom_show_allios( c.sp.spind,c.ios.edges,sizes,rows,cols )

    select = true;
    %correct mistakes
    while select
        [co,ro] = getpts();
        close
        select = ~isempty(co);
        if ~isempty(co)
            % Convert the coordinates into the index of the images selected
            ro = floor((ro-1)/sizes(1))+1;
            co = floor((co-1)/sizes(2))+1;
            alli = sub2ind([rows,cols],ro,co);
            % In case you click twice on the same one
            alli = unique(alli); 
            for i = alli'
                c.ios.edges(:,i) = nan(2,1);
                c = pom_correct_ios(c,channel,i);
                c = pom_anthis_ios( c,channel,i,im_bg,true );
            end
            
        figure
        imshow(big_ima,[],'InitialMagnification','fit')
        title('Select the wrong ios and click enter')
        hold on
        pom_show_allios( c.sp.spind,c.ios.edges,sizes,rows,cols )

        end
    end

end
end

