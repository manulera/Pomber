close all
c = out.cells{1};



for i = 10:size(c.video{2},3)
    ima = c.video{2}(:,:,i);
    ima = ima.*c.masks(:,:,i);

    cell_bg = image_background(ima(ima~=0));

    
    
    
    [what1,where1] = max(ima);
    keep = what1>1;
    x = 1:numel(where1);
    y = movmedian(where1,10);
    z = what1(keep);
    diff_maker = 3;
    
    
    
    z_sum = [];
    j = 1;
    for d = diff_maker+1:(numel(z)-diff_maker)
        lims1 = (d-diff_maker):d;
        lims2 = d:(d+diff_maker);
        z_sum(j) = abs(sum(z(lims2))-sum(z(lims1)));
        j = j+1;
    end
    pp2 = peakfinder(z_sum')+diff_maker;
    
    pp3 = movstd(where1,5)<3;
    
    pp3 = pipe_remove_small_regionprops(pp3,4);
    % Remove the ones with very small values
    pp3 = pp3 & what1>0.2*max(what1);
    
    % Get the ones on the sides
    still=1;
   
    while still && any(pp3)
        still=0;
        edges = [0 diff(pp3)];
        ed_ind = find(edges);
       
        if numel(ed_ind)<3
            break
        end
        
        % Do first the smallest one
        bwl = bwlabel(pp3);
        values = [];
        for j = 1:max(bwl)
            values(j) = sum(bwl==j);
        end
        biggest_region = max(values);
        if sum(bwl==1)<biggest_region
            
            edge_left = ed_ind(2:3);
            edge_left(1) = edge_left(1)-1;
            if abs(diff(y(edge_left))./diff(x(edge_left)))>1.5||diff(x(edge_left))>20||diff(y(edge_left))>10
                still=1;
                pp3(1:edge_left(1))=0;
            end
        end
        
        if sum(bwl==max(bwl))<biggest_region
            
            edge_right = ed_ind(end-2:end-1);
            edge_right(1) = edge_right(1)-1;
            if abs(diff(y(edge_right))./diff(x(edge_right)))>1.5||diff(x(edge_right))>20||diff(y(edge_right))>15
                still=1;
                pp3(edge_right(2):end)=0;
            end
        end
    end
    
    figure('Position', [300 300 1200 900])
    title(i)
    subplot(3,1,1)
    imshow(ima,out.im_info.contrast(2,:),'InitialMagnification','Fit')
    
    hold on
    scatter(x,y)
    xx = x(pp3);
    yy = y(pp3);
    scatter(xx,yy)
%     lims = pp2(1):pp2(end);
%     x = x(lims);
%     y = y(lims);
%     plot(1:numel(where1),where1,'red')
%     pf = polyfit(x,y,3);
%     plot(x,polyval(pf,x),'green','Linewidth',2)
%     scatter(xx,yy)
    pf = polyfit(xx,yy,3);
    plot(xx,polyval(pf,xx),'green','Linewidth',2)
    


    subplot(3,1,2)
    plot(where1)

    subplot(3,1,3)
    plot(slope)
    % Old method
    % z_diff = z((diff_maker+1):end)-z(1:end-diff_maker);
    %     pp1 = peakfinder(z_diff');
   
end
