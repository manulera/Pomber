function [ handles ] = pom_slider_t( handles )
    handles.currentt=round(get(handles.slider_t,'Value'));
    
    if ~handles.tog_fastscroll.Value && handles.currentcell
        if ismember(handles.currentcell,handles.frame_list{handles.currentt})
            c = handles.cells{handles.currentcell};
            i_logic = handles.currentt==c.list;
            ind_cell = find(i_logic);
            set(handles.slider_cell,'Value',ind_cell)
        end
    end
    pom_show(handles)
    
    
end

