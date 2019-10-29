function [ x,y,p ] = mask2line_EB1( bin2,ima,resolution )
    lis = regionprops(bin2,ima,'PixelList','PixelValues','MajorAxisLength');
    if isempty(lis)
        x = nan;
        y = nan;
        return
    end
    x = [];
    y = [];
    for i=1:numel(lis)
        x = [x; lis(i).PixelList(:,1)];
        y = [y; lis(i).PixelList(:,2)];
    end
    
    
    
    p = linortfit2(x,y);
    xx = linspace(min(x)-5,max(x)+5);
    yy = polyval(p,xx);
    
%   TODO: this remains to be revisitted at some point.
%     [x1,y1] = cut_line(x,y,xx,yy,1);
%     [x2,y2] = cut_line(x,y,xx,yy,5);
%     
%     figure
%     subplot(3,1,1)
%     imshow(ima,[])
%     hold on
%     plot(x2,y2)
%     plot(x1,y1)
%     subplot(3,1,2)
%     l = sum(sqrt(sum(diff([x1(:) y1(:)]).^2,2)));
%     s = resamplePolyline([x1(:) y1(:)],ceil(l));
%     plot(improfile(ima,s(:,1),s(:,2),ceil(l)))
%     subplot(3,1,3)
%     l = sum(sqrt(sum(diff([x2(:) y2(:)]).^2,2)));
%     s = resamplePolyline([x2(:) y2(:)],ceil(l));
%     plot(improfile(ima,s(:,1),s(:,2),ceil(l)))
    [x,y] = cut_line(x,y,xx,yy,5);
end

