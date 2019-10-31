function [ merge ] = make_merge( c1,c2,cont1,cont2 )
    % So far its red and green
    %% Normalize channels
    if numel(size(c1))==2
    
        merge = nan([size(c1) 1 3]);
    else
        merge = nan([size(c1) 3]);
    end
    
    c1n = (c1-cont1(1)) /(diff(cont1));
    c2n = (c2-cont2(1)) /(diff(cont2));
    c1n(c1n<0)=0;
    c2n(c2n<0)=0;
    %c1n(c1n>255)=255;
    %c2n(c2n>255)=255;
    merge(:,:,:,1) = c1n;
    merge(:,:,:,2) = c2n;
    merge(:,:,:,3) = c2n;
    
end

