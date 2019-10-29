function [handles] = pom_reanalyze(handles)
    for i =1:numel(handles.cells)
        handles.cells{i} = handles.cells{i}.repeat(handles.im_info);
    end
end

