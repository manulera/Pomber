function [ handles ] = cprof_copy( handles )
axes(handles.ax_1)
[~,x]=ginput(3);
ind = floor((x-1)/handles.cropsize(1))+1;
sour = ind(1);
dest_all = min(ind(2:3)):max(ind(2:3));

% Check that the source is right
if isnan(handles.list(sour))
    warndlg('Empty source!')
else
    for dest = dest_all
         
        handles.masks(:,:,dest) = handles.masks(:,:,sour);
        handles.cont{dest} = handles.cont{sour};
    end
end
end

