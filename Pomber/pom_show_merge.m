function [] = pom_show_merge(this_axis,handles)
    
    
    set(handles.tog_c1,'Value',0)
    set(handles.tog_c2,'Value',0)
    set(handles.tog_c3,'Value',0)
    
    ima = pom_make_merge(handles);
    imshow(ima,'Parent',this_axis);
    
    % Unmark if not possible
    if isempty(ima)
        set(handles.tog_merge,'Value',0);
    end
    
end

