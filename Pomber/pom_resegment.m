function [ handles ] = pom_resegment( handles )
    c = handles.cells{handles.currentcell};
    for i = 1:numel(handles.video)
        mini_video{i} = handles.video{i}(c.xmain,c.ymain,:,:);
    end
    % Change the current for the full length video
    c.video = rotate_video(mini_video,c.xlims,c.ylims,c.angle);
    output = CellProfile(c,0);
    if isempty(output)
        return
    end
    newcell = cellu(output);
    handles.cells{handles.currentcell} = newcell.update(c,handles.im_info);
    handles = pom_movecell(handles,0);
    [ handles ] = update_frame_list( handles );
    
end

