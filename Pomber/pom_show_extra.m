function [] = pom_show_extra(handles)
    if ~isempty(handles.extra{handles.toggled})
        axes(handles.ax_main)
        hold off
        imshow(handles.extra{handles.toggled}(:,:,handles.currentt),[])
    end
end

