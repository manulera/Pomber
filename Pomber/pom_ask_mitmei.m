function [ c ] = pom_ask_mitmei( c,cats )
    figure
    
    for channel = 1:numel(c.video)
        if channel>3
            % we dont need the merge
            break
        end
        row = (channel-1)*3;
        subplot(3,3,row + 1)
        imshow(c.video{channel}(:,:,1),[])
        subplot(3,3,row+2)
        imshow(c.video{channel}(:,:,round(end/2)),[])
        subplot(3,3, row+3)
        imshow(c.video{channel}(:,:,end),[])
    end

    
    i = listdlg('ListString',cats,'SelectionMode',...
    'single','PromptString',{'What is this cell doing?'});
    c.mitmei = i-1;
    close
end

