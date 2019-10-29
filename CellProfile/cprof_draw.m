function [ handles ] = cprof_draw( handles )
    axes(handles.ax_1)
    [~,x]=ginput(1);
    ind = floor((x-1)/handles.cropsize(1))+1;
    
    [ mask ] = draw_cell( handles.video{handles.dic}(:,:,handles.list(ind)));
    handles = cprof_addpair( handles,mask,2,ind );
end

