function [ contrast ] = calculate_contrast( video,isDIC )
    

    m = mean(video(:));
    s = std(video(:));
    ma = max(video(:));
    if isDIC
        % The DIC channel is normally distributed
        contrast = [m - 3*s, m + 3*s];
    else
        contrast = [m,m+9*s];
    end
    
    % In case the value was negative
    if contrast(1)<0
        contrast(1)=0;
    end
    % In case the value was too big
    if contrast(2)>ma
        contrast(2) = ma;
    end
end

