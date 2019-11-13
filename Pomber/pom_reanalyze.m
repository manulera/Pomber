function [handles] = pom_reanalyze(handles)
    for i =1:numel(handles.cells)
        c = handles.cells{i};
        c.findAllFeatures(handles.video,handles.im_info,handles.extra,1)
    end
end

