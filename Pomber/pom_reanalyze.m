function [handles] = pom_reanalyze(handles)
    for i =1:numel(handles.cells)
        c = handles.cells{i};
        c.findAllFeatures(handles.video,handles.im_info,handles.extra,handles.sum_video,1)
    end
end

