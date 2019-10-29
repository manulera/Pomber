function [ handles ] = cprof_init( handles,in,first_time )
    if nargin<3
        first_time= true;
    end
    handles.first_time = first_time;
    
    handles.restore = in;
    % In case you just close the figure without clicking done, it should
    % return an empty cell.
    handles.output = [];
    if handles.first_time
        handles.dic = in.dic;
        handles.masks = in.rotated_mask(in.ylims,in.xlims);
        handles.list = in.currentt;
        handles.video = in.video;
        %handles.mini_video = in.mini_video;
        handles.size = size(handles.video{handles.dic});
        handles.angle = in.angle;
        handles.xlims = in.xlims;
        handles.ylims = in.ylims;
        %handles.xmain = in.xmain;
        %handles.ymain = in.ymain;
        handles.contrast = in.contrast;
        
        if numel(handles.video)==2
            handles.channels = 2;
        elseif numel(handles.video)>2
            handles.channels = 3;
        end
        for i = 1:handles.channels
            handles.ima_long{i} = handles.video{i}(:,:,in.currentt);
        end

        handles.cropsize = size(handles.ima_long{1}(:,:,1));

        cont = bwboundaries(handles.masks);
        cont = cont{1};
        handles.cont = {cont};
        handles.omit = false;
        handles.keepx = 1:handles.cropsize(1);
        handles.keepy = 1:handles.cropsize(2);
    else
        f = fields(in);
        for i = 1:numel(f)
            name = f{i};
            handles.(name) = in.(name);
        end
    end
    
    % How many frames are shown at the same time in the same image.
    handles.limshow = 11;
    % The position of the slider
    handles.current = 1;

    
end
