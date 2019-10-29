
for i = [15,21,22]
    % The line along the spindle, it can have different number of points
    s = c.sp.spind{i};
    % The background of this image
    bg = c.sp.bg(i);
    % The image
    ima = c.video{2}(:,:,i)-bg;
    % Resample the line of the spindle so that it has as many points as
    % lenght in pixels
    s2 = resamplePolyline(s,ceil(c.sp.len(i)));
    
    % Method 1: derived from Francois proposal
    [p1,mask] = custom_improfile(ima,s2,4);
    
    % Method 2: map each pixels to the closest point in the line
    se = strel('diamond',4);
    % This original mask contains the spindle, we expand it by 4 to get the
    % area that we will take
    mask2 = imdilate(c.sp.mask(:,:,i),se);
    % Second method
    [p2] = thicc_profile(ima,mask2,s2(:,2),s2(:,1));
    
    % Method 3
    
    [p3,mask3] = custom_improfile2(ima,mask2,s2(:,2),s2(:,1));
    
    % Method 2: map each pixels to the closest point in the line
    se = strel('diamond',3);
    % This original mask contains the spindle, we expand it by 4 to get the
    % area that we will take
    mask2 = imdilate(c.sp.mask(:,:,i),se);
    
    [p4,mask4] = custom_improfile2(ima,mask2,s2(:,2),s2(:,1));
    
    figure
    
    subplot(3,1,1)
    imagesc(ima)
    axis equal
    hold on
    plot(s2(:,2),s2(:,1),'red')

    
    subplot(3,1,2)
    imagesc(c.sp.mask(:,:,i))
    axis equal
    hold on
    plot(s2(:,2),s2(:,1),'red')

    subplot(3,1,3)
    plot(p4,'blue','LineWidth',2)
    hold on
    plot(p2,'red')
    plot(p3,'green')
end