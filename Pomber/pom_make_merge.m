function [ handles ] = pom_make_merge( handles )
    
% If the merge channel is already create it, show it
if numel(handles.video)==4
    
    handles.toggled=4;
    set(handles.tog_c1,'Value',0)
    set(handles.tog_c2,'Value',0)
    set(handles.tog_c3,'Value',0)

% If the merge channel is not created, create it
elseif numel(handles.video)==3

    chan2merge = find(handles.an_type>2);
    if numel(chan2merge)==2
        c1 = chan2merge(1);
        c2 = chan2merge(2);
        handles.video{4} = make_merge(handles.video{c1},handles.video{c2},handles.im_info.contrast(c1,:),handles.im_info.contrast(c2,:));
        handles.toggled=4;
        set(handles.tog_c1,'Value',0)
        set(handles.tog_c2,'Value',0)
        set(handles.tog_c3,'Value',0)
    % If no channels to merge, still unmark it
    else
        set(handles.tog_merge,'Value',0)
    end
    

% If there is no possibility to make the merge channel, do not even mark
% the circle
else
    return
    set(handles.tog_merge,'Value',0)
end

end

