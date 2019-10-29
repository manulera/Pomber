function [ ] = cprof_show( handles,only_limits)
    if nargin<2
        only_limits=false;
    end
    
    numframes=numel(handles.list);
    frame_height = size(handles.ima_long{1},1)/numframes;
    
    if ~only_limits
        for i = 1:handles.channels
            axes(handles.(['ax_' num2str(i)]))
            cla; hold off
            imshow(handles.ima_long{i},handles.contrast(i,:))
            hold on
    
            for j = 1:numel(handles.list)
                cont =handles.conts{j};
                if ~isempty(cont)
                    
                    if ~handles.transposing
                        cont(:,1) = cont(:,1)+frame_height*(j-1);
                        plot(cont(:,2),cont(:,1),'yellow')
                    else
                        cont(:,2) = cont(:,2)+frame_height*(j-1);
                        plot(cont(:,1),cont(:,2),'yellow')
                    end
                end
            end
        end
        
    end
    limit_show = str2double(handles.texted_numdisplayed.String);
    
    
    if numframes>limit_show
        x = round(get(handles.slider_main,'Max'))-round(get(handles.slider_main,'Value'))+1;
        
        for i = 1:handles.channels
            axes(handles.(['ax_' num2str(i)]))
            minx = frame_height*(x-1)+1;
            maxx = minx + limit_show*(frame_height-1);
            ylim([minx,maxx])
        end
    end

    
    
end

