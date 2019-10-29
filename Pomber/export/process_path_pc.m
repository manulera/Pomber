function [ xchar ] = process_path_pc( xchar )
ind = strfind(xchar,'\');

if ~isempty(ind)
    xchar2 = xchar(1:ind(1));
    for j = 1:(numel(ind)-1)                    
        xchar2 = [xchar2 xchar(ind(j):ind(j+1))];
    end
    % In case of the last one
    xchar2 = [xchar2 xchar(ind(j+1):end)];
    if ind(end)==numel(xchar)
        xchar2 = [xchar2 '\'];
    end
    xchar = xchar2;
end



end

