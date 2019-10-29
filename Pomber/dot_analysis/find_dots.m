function [ coords ] = find_dots( ima )
    
       
    % Series of thresholding until you reduce to a certain proportion of
    % the image    
    mask = zeros(size(ima));
    [~,keep] = sort(ima(:));
    % Take the ten most intense values
    ini_lim = 10;
    mask(keep(end-ini_lim:end))= 1;
    [lab, numberOfObject] = bwlabel(mask);
    if numberOfObject ==1
        % remove pixels until you have two regions
        while numberOfObject==1 && ini_lim>1
            ini_lim = ini_lim-1;
            mask(keep(end-ini_lim:end))= 1;
            [~, numberOfObject] = bwlabel(mask);
        end
        % in case that doesnt work take the most intense pixels
        if ini_lim == 1
            [ycoords,xcoords] = ind2sub(size(mask),keep(end-1:end));
            coords = [xcoords(:) ycoords(:)];
        end
    end
    if numberOfObject ==2
        rp = regionprops(lab,'Centroid');
        coords = [rp(1).Centroid; rp(2).Centroid];
    elseif numberOfObject >2
        rp = regionprops(lab,'Area','Centroid');
        [~,keep] = sort([rp.Area]);
        coords = [rp(keep(end)).Centroid; rp(keep(end-1)).Centroid];
    end
    % Swap columns to be consistent
    coords(:,[1 2]) = coords(:,[2 1]);

end


