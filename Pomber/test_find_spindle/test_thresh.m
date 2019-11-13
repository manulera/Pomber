reader = Tiff('TP2552_0_wave_3_max_probs1.tif');
% Count
i = 1;
thresh_movie=[];
while true
    
    subimage = reader.read();
    thresh_movie(:,:,i) = subimage;
    reader.nextDirectory();
    if reader.lastDirectory()
        break
    end
    % Skip the inverted image
    reader.nextDirectory();
    if reader.lastDirectory()
        break
    end
    
    i= i+1;
end

drift = read_drift_file('TP2552_0.txt');

thresh_movie = apply_drift(thresh_movie,drift);

%%


all_pars = [];
for i = c.list
    figure
    ima = video{3}(:,:,i);
    mode =1;
    
    if mode==1
        mask = c.masks(:,:,i).*(thresh_movie(:,:,i)>0.8);
    else
        mask = c.masks(:,:,i);
    end
    
    lis = regionprops(mask,ima,'PixelList','PixelValues');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    zz = lis.PixelValues;
    if mode ==1
        bg=0;
    else
        bg = median(zz);
    end
    zz_b = zz-bg;
    
    xc = sum(xx.*(zz_b))/sum(zz_b);
    yc= sum(yy.*(zz_b))/sum(zz_b);
    
    lis = regionprops(mask,'Orientation');
    sugg_ang = -deg2rad(lis.Orientation);
    
    
    [pars] = weightedOrthogonalFit(ima,mask,bg,[sugg_ang,xc,yc,0],1,1);
    
    
    [x_box,y_box] = expandBoundingBox(c.masks(:,:,1),0.6);
    imshow(ima,[],'InitialMagnification','fit');
    hold on
    scatter(xc,yc)
    
    ylim(y_box([1,end]))
    xlim(x_box([1,end]))
    
%     mask = c.masks(:,:,i).*(thresh_movie(:,:,i)>0.4);
%     [yy,xx] = find(mask);
%     scatter(xx,yy);
%     
% %     xx = lis.PixelList(:,1);
% %     yy = lis.PixelList(:,2);
%     
%     theta = pars(1);
%     R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
%     
%     % Center at the point
%     xx = xx-pars(2);
%     yy = yy-pars(3);
%     
%     coords = [xx yy] * R;
%     
%     xx = coords(:,1);
%     yy = coords(:,2);
%     
%     x = linspace(xx(1),xx(2));
    x =-170:170;
    y = x.^2*pars(4);
    
    
    theta = -pars(1);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    coords = [x; y]' * R;
    x = coords(:,1);
    y = coords(:,2);
    x = x+pars(2);
    y = y+pars(3);
    

    
    mask = c.masks(:,:,i).*(thresh_movie(:,:,i)>0.4);
    
    % Here I could turn the coordinate points from the mask and then use
    % the projection on the line instead of checking whether the line is
    % inside.
    [cont,pieces] = bwboundaries(mask);
    keep = false(size(x));
    
    for j = 1:numel(cont)
        keep = keep | inpolygon(x,y,cont{j}(:,2),cont{j}(:,1));        
    end

    plot(x(keep),y(keep))
    scatter(pars(2),pars(3))
    
%     figure
%     imagesc(pieces);
%     ylim(y_box([1,end]))
%     xlim(x_box([1,end]))
    pause(0.1)
end