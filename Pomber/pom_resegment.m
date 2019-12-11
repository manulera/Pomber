function [ handles ] = pom_resegment( handles )
    c = handles.cells{handles.currentcell};
    input = struct();
    input.contrast = handles.im_info.contrast;
    input.tlen = handles.tlen;
    DIC = find(handles.an_type==2);
    input.dic = DIC;
    input.video = handles.video;
    input.masks = c.masks;
    input.list = c.list;
    output = CellProfile(input,0);
    
    if isempty(output)
        return
    end
    newcell = cellu(output.masks,output.list,handles.an_type);
    newcell.update(c,handles.video,handles.im_info,handles.extra,handles.sum_video);
    handles.cells{handles.currentcell} = newcell;
    handles = pom_movecell(handles,0);
    [ handles ] = update_frame_list( handles );
    
end

