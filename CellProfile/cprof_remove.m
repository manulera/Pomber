function [ handles ] = cprof_remove( handles,ind )
if nargin<2
    ind = false;
end

if numel(handles.list)==1
    return
end
numframes=numel(handles.list);
frame_height = size(handles.ima_long{1},1)/numframes;

% if ~ind
%     axes(handles.ax_1)
%     [~,x]=ginput(1);
%     ind = floor((x-1)/frame_height)+1;
% end

if ind == 1 || ind == numel(handles.list)
    handles.masks(:,:,ind) = [];
    handles.list(ind) = [];
else
    % This behaviour is not used anymore, but was intended to be used in
    % case you want to ignore certain frames.
    handles.masks(:,:,ind) = 0;
    
end

handles = cprof_update(handles);
if ind==1
    maxsl= get(handles.slider_main,'Max');
    set(handles.slider_main,'Value',maxsl);
else
    set(handles.slider_main,'Value',1);
end

end

