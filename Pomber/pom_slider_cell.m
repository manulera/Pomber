function [ handles ] = pom_slider_cell( handles )
    if handles.currentcell
        %if ismember(handles.currentcell,handles.frame_list{handles.currentt})
            c = handles.cells{handles.currentcell};
            i = round(get(handles.slider_cell,'Value'));
            handles.currentt = c.list(i);
            set(handles.slider_t,'Value',handles.currentt)
        %end
    end
end

