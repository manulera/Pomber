function [handles] = pom_change_cond(handles,val)
    handles.cells{handles.currentcell}.mitmei = val-1;
end

