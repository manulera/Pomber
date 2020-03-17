function [ handles ] = pom_pop_channel( handles,val,channel )
handles.an_type(channel) = val;
% Recalculate the contrast
isDIC = handles.an_type(channel)==2;

handles.im_info.contrast(channel,:) = calculate_contrast(handles.video{channel},isDIC);

% @TODO REMOVE THIS
% if ~isDIC && isnan(handles.im_info.im_bg(1,channel))
%     handles.im_info.im_bg(:,channel) = video_background(handles.video{channel});
% end

% If it is the spindle load the extra

if val==3
    
end

end

