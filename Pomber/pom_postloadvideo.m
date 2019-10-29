function [handles] = pom_postloadvideo(handles)
    channels = numel(handles.video);
    handles.im_info.contrast = nan(channels,2);
    if ~isfield(handles.im_info,'resolution')
        handles.im_info.resolution = nan;
    end
    %% Set up the contrast
    % Here give the user the possibility to trim the video in case there is a
    % dark part. 

    %trim = input('Provide a trimming value (default for spinning 1 was 50)');
    trim=1;
    if trim<1
        trim =1;
    end

    for i = 1:channels
        if trim>1
            handles.video{i} = handles.video{i}(:,trim:end,:);
        end
        % Assumes first channel is DIC
        handles.im_info.contrast(i,:) = calculate_contrast(handles.video{i},i==1);
    end

end

