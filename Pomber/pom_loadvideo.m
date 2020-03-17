function [ handles ] = pom_loadvideo( handles,do_postload)

if nargin<2
    do_postload=true;
end

%Extract the video and lenght of it
[full_video,handles.tlen,handles.channel_names,~,handles.time,handles.pos_name,handles.pos_index,handles.all_pos_names]=readMetamorphNd(handles.pathfile, handles.ndfile,handles.pos_name);

handles.video = cell(size(full_video));
handles.sum_video = cell(size(full_video));

for i = 1:numel(full_video)
    handles.video{i} = squeeze(max(full_video{i},[],3));
    handles.sum_video{i} = squeeze(sum(full_video{i},3));
end

% handles.sum_video = readMetamorphNd(handles.pathfile, handles.ndfile,'sum',handles.pos_name);


if do_postload
    handles = pom_postloadvideo(handles);
end

end