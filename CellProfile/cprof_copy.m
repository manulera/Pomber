function [ handles ] = cprof_copy( handles )
axes(handles.ax_1)
[~,x]=ginput(3);
numframes=numel(handles.list);
frame_height = size(handles.ima_long{1},1)/numframes;
ind = floor((x-1)/frame_height)+1;
sour = ind(1);
dest_all = min(ind(2:3)):max(ind(2:3));

% Check that the source is right
if isnan(handles.list(sour))
    warndlg('Empty source!')
else
    for dest = dest_all
        handles.masks(:,:,dest) = handles.masks(:,:,sour);
    end
end
handles=cprof_update(handles);
end

