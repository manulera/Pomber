function [ handles ] = pom_import( handles,isfirst )

if isfirst && strcmp(handles.pos_name,'')
    [handles.ndfile,handles.pathfile] = uigetfile('*.nd','Locate the nd file');
end
if ~handles.ndfile
    return
end
handles= pom_loadvideo( handles);

channels = numel(handles.video);
if isfirst
    % Initialize variables only when loading the video for the first time
    handles.currentt=1;
    handles.frame_list = cell(1,handles.tlen);
    handles.an_type = ones(1,channels);
    handles.im_info.im_bg = nan(handles.tlen,channels);
end
handles.ed_resolution.String = num2str(handles.im_info.resolution);

if channels<3
        % Delete some useless objects if there is only two channels
        delete(handles.pop_c3)
        delete(handles.tog_c3)
        delete(handles.tog_merge)
        delete(handles.ax_closeup3)
        delete(handles.ax_closeup4)
end
%% Update the slider
if handles.tlen~=1
set(handles.slider_t,'Max',handles.tlen);
set(handles.slider_t,'Min',1);
set(handles.slider_t,'Value',handles.currentt);
set(handles.slider_t,'SliderStep',[1, 1]/(handles.tlen-1));
else
delete(handles.slider_t)    
end
for i = 1:numel(handles.channel_names)
    handles.(['tog_c' num2str(i)]).String = handles.channel_names{i};
end
%pom_askresolution

handles = pom_load_categories(handles,0);

end

