function [ handles ] = pom_addcell( handles, newcell )
    
    handles.cells = [handles.cells {newcell}];
    ind = numel(handles.cells);
    for i = newcell.list
        handles.frame_list{i} = [handles.frame_list{i} ind];
    end
    handles.currentcell = numel(handles.cells);
    handles = pom_analyze(handles);
    handles = pom_movecell(handles,0);
end

