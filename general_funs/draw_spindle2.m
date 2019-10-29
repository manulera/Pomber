function [ mask ] = draw_spindle2( ima1,caption,prev_cont )
    if nargin<2
        caption = [];
    end
    figure
    imshow(ima1,[],'InitialMagnification','fit');
    if ~isempty(caption)
        title(caption)
    end
    [x,y] = getpts();
    mask = poly2mask(x,y,size(ima1,1),size(ima1,2));
    close
end

