function [  ] = cprof_show( handles )
    for i = 1:handles.channels
        axes(handles.(['ax_' num2str(i)]))
        cla; hold off
        % This function is kind of crappy but does the job
        cprof_plotlong( handles.video{i},handles.contrast(i,:),handles.cont,handles.cropsize, handles )
        hold on
    end
    
    %% Update/Use the slider
    numframes = numel(handles.list);
    if numframes>handles.limshow
        
        maxsl = numframes-handles.limshow+1;
        set(handles.slider_main,'Max',maxsl);
        set(handles.slider_main,'Min',1);
        set(handles.slider_main,'SliderStep',[1, 1]/(maxsl-1));
        
        set(handles.slider_main,'Value',handles.current);
        x = get(handles.slider_main,'Max')-handles.current +1;
        for i = 1:handles.channels
            axes(handles.(['ax_' num2str(i)]))
            minx = handles.size(1)*(x-1)+1;
            maxx = minx + handles.limshow*(handles.size(1)-1);
            ylim([minx,maxx])
        end
    end
    
end

