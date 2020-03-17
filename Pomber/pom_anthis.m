function [ handles ] = pom_anthis( handles,onstack )
if nargin<2
    onstack=false;
end
if ismember(handles.currentcell,handles.frame_list{handles.currentt})
    if onstack
        
    else
        handles.cells{handles.currentcell}.correct(handles.video,handles.currentt,handles.im_info,handles.extra,handles.sum_video);
    end
    
end
end