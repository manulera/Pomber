function [ handles ] = pom_loadvideo( handles,do_postload)

if nargin<2
    do_postload=true;
end

%Extract the video and lenght of it
[handles.video,handles.tlen,handles.channel_names,~,handles.time,handles.pos_name,handles.pos_index,handles.all_pos_names]=ReadImages3(handles.pathfile, handles.ndfile,1,handles.pos_name);

if do_postload
    handles = pom_postloadvideo(handles);
end

end