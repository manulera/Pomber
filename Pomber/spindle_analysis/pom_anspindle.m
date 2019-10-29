% old function
function [ obj ] = pom_anspindle(obj,c,channel,repeat,resolution,im_bg )

if nargin<3
    repeat = true;
end
if repeat ==2
    c = pom_postspindle(c,channel,im_bg);
    return
else
sizes = size(c.video{channel});
rows = 7;
cols = ceil(sizes(3)/rows);
big_ima = zeros(rows*sizes(1),cols*sizes(2));

% This was in case I wanted to do this in subplots instead of a big image,
% I think this is better though
%index = reshape(1:(cols*rows), cols, rows).';

if repeat
    spinds = obj.spind;
    conts = obj.cont;
%     masks = c.sp.mask;
else
    spinds = cell(1,sizes(3));
    conts = cell(1,sizes(3));
    masks = zeros(sizes);
end
for i = 1:sizes(3)

    ima = c.video{channel}(:,:,i);
    ima = ima.*c.masks(:,:,i);
    
    if ~repeat % We still have to build the big image thats why we loop
        spinmask = find_spindle(ima);
        masks(:,:,i) = spinmask;
        cont = bwboundaries(spinmask);
        % Could be that it didnt find anything
        if ~isempty(cont)
            conts{i} = cont{1};
        else
            conts{i} = [];
        end

        [ x,y ] = mask2line( spinmask,ima,resolution );
        % To circunvent the fact that sometimes is column vector and sometimes
        % row
        spinds{i}=[y(:) x(:)];
    end
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
            % [spinds{i},masks(:,:,i),conts{i}]=draw_spindle(ima,resolution,masks(:,:,i),conts{i});
            [spinds{i}]=draw_spindle(ima,resolution,spinds{i});
        end
        figure
        imshow(big_ima,[],'InitialMagnification','fit')
        title('Select the wrong spindles and click enter')
        hold on
        pom_show_allspind( spinds,conts,sizes,rows,cols )
    end
end
c.an_type(channel) = 3; % The id of the analysis
obj.spind = spinds;
% c.sp.mask = masks;
obj.cont = conts;


obj = pom_postspindle(obj,c,channel,im_bg);

end
end

