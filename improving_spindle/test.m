c = out.cells{1};
extra_mask = 1;
prev_ima2 = 1;
all_ima = {};
all_conts = {};
all_extra = {};
for i = 1:size(c.video{2},3)
    ima = c.video{2}(:,:,i);
    ima = ima.*c.masks(:,:,i).*extra_mask;
    e = bwboundaries(extra_mask);
    all_extra{i}= e{1};
    %figure
    ima2 = thresh_spindle(ima);
    all_ima{i} = ima;
    %imshow(ima,out.im_info.contrast(2,:),'InitialMagnification','Fit')
    %hold on
    cont = bwboundaries(ima2);
    
    if ~isempty(cont)    
        cont = cont{1};
        all_conts{i} = cont;
        %h = plot(cont(:,2),cont(:,1),'red');
    end
    
    se = strel('disk',15,0);
    extra_mask_i = imdilate(ima2,se);
    if sum(ima2(:))>sum(prev_ima2(:))
        extra_mask = extra_mask_i;
        prev_ima2 = ima2;
    end
end

%%
for i = size(c.video{2},3):-1:1
    figure
    ima = c.video{2}(:,:,i);
    imshow(ima,out.im_info.contrast(2,:),'InitialMagnification','Fit')
    hold on
    cont = all_conts{i};
    plot(cont(:,2),cont(:,1),'red')
    cont = all_extra{i};
    plot(cont(:,2),cont(:,1),'green')
    
end