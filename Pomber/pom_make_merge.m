function [ima] = pom_make_merge(handles)
    ima=[];
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
        end
    end
end

