function [ handles ] = cprof_add( handles,isnext )

skip = false;

if isnext
    current = max(handles.list);
    next = current +1;
    prev_mask = size(handles.masks,3);
    if next>handles.size(3)
        skip = true;
    else
        handles.list = [handles.list next];
    end
    
else
    current = min(handles.list);
    next = current -1;
    prev_mask = 1;
    if next<1
        skip = true;
    else
        handles.list = [next handles.list];
    end
    
end

if ~skip
    
    mask = handles.masks(:,:,prev_mask);
    handles = cprof_addpair( handles,mask,isnext );
    
end

    handles = cprof_update(handles);
    
    if isnext
        set(handles.slider_main,'Value',1);
    else
        maxsl= get(handles.slider_main,'Max');
        set(handles.slider_main,'Value',maxsl);
    end
end

