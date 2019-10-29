function [ out] = find_ios_edges( int )
    
    l = numel(int);
    x_peaks = peakfinder(int);
    
    
    % Left
    x1 = x_peaks(1);
    x2 = x_peaks(end);
    left_lim = nan;
    right_lim = nan;
    if x1<l*0.1
        % Look towards the right for the first up
        limit = find(diff(int(x1:end))>0);
        
        if ~isempty(limit)
            left_lim = x1+limit(1)-1;
        end
    end
    
    % Right
    if x2>l*0.9
        % Look towards the right for the first up
        limit = find(diff(int(x2:-1:1))>0);
        
        if ~isempty(limit)
            right_lim = x2-limit(1)+1;
        end
    end
    out = [left_lim,right_lim];
end

