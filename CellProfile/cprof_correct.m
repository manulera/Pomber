function [ handles ] = cprof_correct( handles )
axes(handles.ax_1)
[~,x]=ginput(1);
ind = floor((x-1)/handles.cropsize(1))+1;
ima = handles.video{handles.dic}(:,:,handles.list(ind));

repeat = true;
while repeat == true
    figure
    imshow(ima,[],'InitialMagnification','fit');
    [ ima,mask, answer ] = interactive_cell( ima,false);
    switch answer
        case 'Yes'
            handles = cprof_addpair( handles,mask,2,ind );
            repeat=false;
        case 'Repeat'
            
        case 'Just draw'
            [ mask ] = draw_cell( ima );
            handles = cprof_addpair( handles,mask,2,ind );
            repeat = false;
    end
end

    
end

