int_all = c.ios.int;

for i = 1:numel(int_all)
    l = numel(int);
    int = int_all{i};
    x_peaks = peakfinder(int);
    chosen = x_peaks>l*0.9 | x_peaks<l*0.1;
    
    
    % Left
    x1 = x_peaks(1);
    x2 = x_peaks(end);
    left_lim = [];
    right_lim = [];
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
    
    figure
    plot(int)
    hold on
    scatter(left_lim,int(left_lim))
    scatter(right_lim,int(right_lim))
end