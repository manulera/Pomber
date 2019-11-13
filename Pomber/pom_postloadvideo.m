function [handles] = pom_postloadvideo(handles)
    channels = numel(handles.video);
    handles.im_info.contrast = nan(channels,2);
    if ~isfield(handles.im_info,'resolution')
        handles.im_info.resolution = nan;
    end
    %% Set up the contrast

    for i = 1:channels
        % Assumes first channel is DIC
        handles.im_info.contrast(i,:) = calculate_contrast(handles.video{i},i==1);
    end
    
    handles.extra = cell(1,channels);
end

