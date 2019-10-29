function [ handles ] = cprof_draw( handles )
    axes(handles.ax_1)
    [~,x]=ginput(1);
    
    numframes=numel(handles.list);
    frame_height = size(handles.ima_long{1},1)/numframes;
    ind = floor((x-1)/frame_height)+1;
    
    [ mini_mask ] = draw_cell( handles.video{handles.dic}(handles.y_box,handles.x_box,handles.list(ind)));
    mask = zeros(handles.size(1:2));
    mask(handles.y_box,handles.x_box) = mini_mask;
    handles = cprof_addpair( handles,mask,2,ind );
    handles=cprof_update(handles);
end

