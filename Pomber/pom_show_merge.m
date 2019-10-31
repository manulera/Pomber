function [] = pom_show_merge(handles)
    
    
    set(handles.tog_c1,'Value',0)
    set(handles.tog_c2,'Value',0)
    set(handles.tog_c3,'Value',0)
    % If the merge channel is not created, create it
    if sum(handles.an_type>2)>=2
        chan2merge = find(handles.an_type>2);
        if numel(chan2merge)==2
            t = handles.currentt;
            c1 = chan2merge(1);
            c2 = chan2merge(2);
            ima1 = handles.video{c1}(:,:,t);
            ima2 = handles.video{c2}(:,:,t);
            cont1 = handles.im_info.contrast(c1,:);
            cont2 = handles.im_info.contrast(c2,:);
            
            ima = squeeze(make_merge(ima1,ima2,cont1,cont2));
            imshow(ima);
            return
        
        end
    end
    % Unmark if not possible
    set(handles.tog_merge,'Value',0);
    
end

