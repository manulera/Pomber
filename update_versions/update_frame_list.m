function [ handles ] = update_frame_list( handles )
    handles.frame_list = cell(1,numel(handles.frame_list));
    
    for i =1:numel(handles.cells)
        c = handles.cells{i};
        for j = c.list
            handles.frame_list{j} = sort([handles.frame_list{j} i]);
        end
    end

end

