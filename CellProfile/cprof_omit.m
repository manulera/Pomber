function [ handles ] = cprof_omit( handles, ishoriz )
    axes(handles.ax_1)
    gca; hold off
    ima = handles.video{handles.dic}(:,:,handles.list(1));
    imshow(ima,[])
    [y,x] = ginput(2); y = round(y); x = round(x);
    handles.omit = true;
    if ishoriz
        if x(2)>x(1)
            handles.keepx = 1:x(1);
        else
            handles.keepx = x(1):size(ima,1);
        end
    else
        if y(2)>y(1)
            handles.keepy = 1:y(1);
        else
            handles.keepy = y(1):size(ima,2);
        end
    end

    
end

