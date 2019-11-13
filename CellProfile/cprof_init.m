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
        handles.masks = in.masks;
        handles.video = in.video;        
        handles.contrast = in.contrast;
        handles.list = in.list;
    else
        f = fields(in);
        for i = 1:numel(f)
            name = f{i};
            handles.(name) = in.(name);
        end
    end
    
    handles.size = size(handles.video{handles.dic});
    if numel(handles.video)==2
        handles.channels = 2;
    elseif numel(handles.video)>2
        handles.channels = 3;
    end
    
    [handles] = cprof_update(handles);
    set(handles.slider_main,'Value',1);
end
