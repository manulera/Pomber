function [ c ] = pom_andots( c,channel,repeat )
if nargin<3
    repeat = false;
end
if repeat==2
    % So far we change nothing
    return
end

sizes = size(c.video{channel});
rows = 6;
cols = ceil(sizes(3)/rows);
big_ima = zeros(rows*sizes(1),cols*sizes(2));

if repeat
    coords = c.dots.coords;
else
    coords = cell(1,sizes(3));
end
for i = 1:sizes(3)

    ima = c.video{channel}(:,:,i);
    ima = ima.*c.masks(:,:,i);
    
    if ~repeat % We still have to build the big image thats why we loop
        coords{i} = find_dots(ima);
    end
    [ro,co] = ind2sub([rows,cols],i);
    xlims = ((ro-1)*sizes(1)+1):(ro*sizes(1));
    ylims = ((co-1)*sizes(2)+1):(co*sizes(2));
    big_ima(xlims,ylims) = ima;
end

figure
imshow(big_ima,[],'InitialMagnification','fit')
title('Select the wrong dots and click enter')
hold on
pom_show_alldots( coords,sizes,rows,cols )
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
            ima = c.video{channel}(:,:,i).*c.masks(:,:,i);
            figure
            imagesc(ima)
            axis equal
            [y,x] = ginput(2);
            coords{i} = [x(:) y(:)];
            close
        end
    figure
    imshow(big_ima,[],'InitialMagnification','fit')
    title('Select the wrong spindles and click enter')
    hold on
    pom_show_alldots( coords,sizes,rows,cols )

    end
end
c.an_type(channel) = 5; % The id of the analysis
c.dots.coords = coords;
c.dots.dist = nan(1,numel(coords));
for i = 1:numel(coords)
    c.dots.dist(i) = sqrt(sum(diff(coords{i}).^2));
end
end

