function [ bin2 ] = find_spindle_EB1( ima )
    ima2 = imgaussfilt(ima,2);
    perc = 0.10;
    % Series of thresholding until you reduce to a certain proportion of
    % the image
    imanonan = ima2(ima~=0);
    total = numel(imanonan);
    % MAybe this helps to elinate extreme values
    maxi = max(ima(:));
    
    imat = ima;
    imat(imat>maxi*0.8) = maxi*0.8;
    thresh = multithresh(imat,3);
    labs = imquantize(ima,thresh);
    bin2 = bwareaopen(labs>2,5);
    if sum(bin2(:))/total>perc
        bin2 = bwareaopen(labs>3,5);
        if sum(bin2(:))/total>perc
            bin2 = labs>3;
        end
    end
    
    
    [~, numberOfObject] = bwlabel(bin2);
    if numberOfObject >1 
        % If the objects take up a small percentage of the total, merge
        % them
        if sum(bin2(:))/total<perc
            bin2 = bwconvhull(bin2);
        % Otherwise, keep the biggest one
        else
            labs = bwlabel(bin2);
            rp = regionprops(bin2,'Area');
            [~,keep] = max([rp.Area]);
            bin2 = labs==keep;
        end
    end
    bin2 = imfill(bin2,'holes');

end

