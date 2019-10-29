function [edges] = spindleEdgesLogical(data,background)
    

    a=data>background;

    k    = find(diff(a) ~= 0);      % Indices of changed values

    iterator = 2:2:numel(k);
    sums = zeros(1,numel(iterator));

    for i = 1:numel(iterator)
        ii = iterator(i);
        sums(i) = sum(data(k(ii-1):k(ii)));
    end

    [~,bb]=max(sums);

    edges = k([bb*2-1,bb*2]);
end

