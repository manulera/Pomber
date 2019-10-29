function [  ] = cprof_plotlong( video,contrast,cont_all,cropsize,handles )
    
    % Make the long image
    ima_long = [];
    
    for i = handles.list
        ima_long = cat(1,ima_long,video(:,:,i));
    end
    imshow(ima_long,contrast)
    hold on
    for i = 1:numel(handles.list)
        cont = cont_all{i};
        if ~isempty(cont)
            cont(:,1) = cont(:,1)+cropsize(1)*(i-1);
            plot(cont(:,2),cont(:,1),'yellow')
        end
    end


end