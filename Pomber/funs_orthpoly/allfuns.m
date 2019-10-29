function [ x,y ] = cut_line( x,y,g,S,thresh )
% When we fit a line to a vloud of points, if its almost a vertical line
% the extremes of the line are clearly outside of the cloud of points, this
% cuts a line keeping only the points that are really inside of the line

if nargin<5
    thresh = 1;
end


xx = linspace(min(x),max(x))';
yy = dopVal(g,xx,S);

all_dis = nan(numel(x),numel(yy));
for i = 1:numel(x)
all_dis(i,:) = (xx-x(i)).^2 + (yy-y(i)).^2;
end
keep = min(all_dis,[],1)<thresh;

x = xx(keep);
y = yy(keep);

end

function [ c ] = pom_anspindle(c,channel )

sizes = size(c.video{channel});
rows = 4;
cols = ceil(sizes(3)/rows);
big_ima = zeros(rows*sizes(1),cols*sizes(2));

% This was in case I wanted to do this in subplots instead of a big image,
% I think this is better though
%index = reshape(1:(cols*rows), cols, rows).';
spinds = cell(1,sizes(3));
conts = cell(1,sizes(3));
masks = zeros(sizes);

for i = 1:sizes(3)
    
    ima = c.video{channel}(:,:,i);
    ima = ima.*c.masks(:,:,i);
    
    spinmask = find_spindle(ima);
    masks(:,:,1) = spinmask;
    cont = bwboundaries(spinmask);
    conts{i} = cont{1};

    [ x,y ] = mask2line( spinmask,ima );
    spinds{i}=[y x];
    [ro,co] = ind2sub([rows,cols],i);
    xlims = ((ro-1)*sizes(1)+1):(ro*sizes(1));
    ylims = ((co-1)*sizes(2)+1):(co*sizes(2));
    big_ima(xlims,ylims) = ima;
end
figure
%set(gcf, 'Position', get(0, 'Screensize'));
imshow(big_ima,[],'InitialMagnification','fit')
title('Select the wrong spindles and click enter')
hold on
pom_show_allspind( spinds,conts,sizes,rows,cols )
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
            ima = c.video{channel}(:,:,i);
            [spinds{i},masks(:,:,i),conts{i}]=draw_spindle(ima);
        end
        figure
        imshow(big_ima,[],'InitialMagnification','fit')
        title('Select the wrong spindles and click enter')
        hold on
        pom_show_allspind( spinds,conts,sizes,rows,cols )
    end
end
c.an_type(channel) = 3; % The id of the analysis
c.sp.spind = spinds;
c.sp.mask = masks;
c.sp.cont = conts;
c = pom_postspindle(c,channel);

end

