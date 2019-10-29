function [ handles ] = cprof_remove( handles,ind )
if nargin<2
    ind = false;
end

if ~ind
    axes(handles.ax_1)
    [~,x]=ginput(1);
    ind = floor((x-1)/handles.cropsize(1))+1;
end

if ind == 1 || ind == numel(handles.list)
    handles.masks(:,:,ind) = [];
    handles.cont(ind) = [];
    handles.list(ind) = [];
    if ind==1
        handles.current = numel(handles.list)-handles.limshow + 1;
    else
        handles.current = 1;
    end
else
    
    handles.masks(:,:,ind) = 0;
    % I think its better just to get it from the empty contours, otherwise
    % makes things more complicated
    handles.cont{ind} = [];
    
end

end

