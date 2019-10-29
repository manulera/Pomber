function [ mask ] = draw_cell( ima1,caption )
    if nargin<2
        caption = [];
    end
    figure
    imshow(ima1,[],'InitialMagnification','fit');
    if ~isempty(caption)
        title(caption)
    end
    [x,y] = getpts();
    if isempty(x)
        mask = 0;
    else    
        mask = poly2mask(x,y,size(ima1,1),size(ima1,2));
    end
    close
end

