function [handles] = cprof_update(handles)
    
    %% Remake ima_long in all channels
    [handles.ima_long,handles.conts,handles.x_box,handles.y_box,handles.transposing] = cprof_make_imalong(handles.video,handles.list,...
    handles.masks);
    
    %% Update/Use the slider
    limit_show = str2double(handles.texted_numdisplayed.String);
    numframes=numel(handles.list);
    maxsl = numel(handles.list)-limit_show + 1;
    if maxsl<2
        maxsl = 2;
    end
    
    set(handles.slider_main,'Max',maxsl);
    set(handles.slider_main,'Min',1);
    set(handles.slider_main,'SliderStep',[1, 1]/(maxsl-1));
    
end

