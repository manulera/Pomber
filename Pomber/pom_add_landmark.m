function [handles] = pom_add_landmark(handles)
    handles.cells{handles.currentcell}.addLandmark(handles.currentt);
end

