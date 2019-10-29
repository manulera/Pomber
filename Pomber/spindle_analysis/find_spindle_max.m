function [xx,yy] = find_spindle_max(ima,resolution)
    
    movmedian_window = 10;
    movstd_window = 5;
    
    % Threshold to set the edges of the regions 
    std_thresh = 3;
    % Threshold to discard too small regions
    size_thresh = 4;
    % Threshold for intensity
    int_thresh = 0.2;
    % Threshold of difference of x,y or dy/dx between patches
    x_thresh = 20;
    y_thresh = 10;
    der_thresh = 1.5;
    % Threshold to make the cubic polyfit
    if ~isnan(resolution)
        cubic_thresh = 8/resolution;
    else
        cubic_thresh = 0;
    end
    
    
    [what1,where1] = max(ima);
    
    x = 1:numel(where1);
    y = movmedian(where1,movmedian_window);

    keep = movstd(where1,movstd_window)<std_thresh;
    keep = pipe_remove_small_regionprops(keep,size_thresh);

    % Remove the ones with very small values
    keep = keep & what1>int_thresh*max(what1);
    

    % If the x,y or dy/dx values from one region of keep are big, it
    % probably means that there is a mistake. Remove them.
    still=1;
   
    while still && any(keep)
        still=0;
        edges = [0 diff(keep)];
        ed_ind = find(edges);
       
        if numel(ed_ind)<3
            break
        end
        
        % Do first the smallest one
        bwl = bwlabel(keep);
        values = [];
        for j = 1:max(bwl)
            values(j) = sum(bwl==j);
        end
        biggest_region = max(values);
        if sum(bwl==1)<biggest_region
            
            edge_left = ed_ind(2:3);
            edge_left(1) = edge_left(1)-1;
            if abs(diff(y(edge_left))./diff(x(edge_left)))>der_thresh||diff(x(edge_left))>x_thresh||diff(y(edge_left))>y_thresh
                still=1;
                keep(1:edge_left(1))=0;
            end
        end
        
        if sum(bwl==max(bwl))<biggest_region
            
            edge_right = ed_ind(end-2:end-1);
            edge_right(1) = edge_right(1)-1;
            if abs(diff(y(edge_right))./diff(x(edge_right)))>der_thresh||diff(x(edge_right))>x_thresh||diff(y(edge_right))>y_thresh
                still=1;
                keep(edge_right(2):end)=0;
            end
        end
    end

    xx = x(keep);
    % To prevent the effect of the ones we removed
    yy = movmedian(where1(keep),movmedian_window);
    
    if sum(sqrt(diff(xx).^2+diff(yy).^2))>cubic_thresh
        pf = polyfit(xx,yy,3);
    else
        pf = polyfit(xx,yy,1);
    end
    yy = polyval(pf,xx);
end



