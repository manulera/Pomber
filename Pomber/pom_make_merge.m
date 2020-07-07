function [ima] = pom_make_merge(handles,t,video)
    if nargin<2||isempty(t)
        t = handles.currentt;
    end
    if nargin<3||isempty(video)
        video = handles.video;
    end
    ima=[];
    if sum(handles.an_type>2)>=2
        chan2merge = find(handles.an_type>2);
        if numel(chan2merge)==2
            c1 = chan2merge(1);
            c2 = chan2merge(2);
            ima1 = video{c1}(:,:,t);
            ima2 = video{c2}(:,:,t);
            cont1 = handles.im_info.contrast(c1,:);
            cont2 = handles.im_info.contrast(c2,:);
            
            ima = squeeze(make_merge(ima1,ima2,cont1,cont2));
        end
    end
end

