function [ handles ] = cprof_retry( handles )
    axes(handles.ax_1)
    [~,x]=ginput(1);
    ind = floor((x-1)/handles.cropsize(1))+1;
    ima = handles.video{handles.dic}(:,:,handles.list(ind));
    
    if isempty(handles.cont{ind})
        warndlg('You cannot retry from blank, copy one and retry')
    else
        if ~handles.omit
            cont = resamplePolyline(handles.cont{ind},200);
            [ ~,mask ] = grow_cell( ima,cont,100 );
        else
            mask = handles.masks(handles.keepx,handles.keepy,ind);
            cont = bwboundaries(mask);
            cont = cont{1};
            cont = resamplePolyline(cont,200);
            [ ~,minimask ] = grow_cell( ima(handles.keepx,handles.keepy),cont,100 );
            % A black mask
            mask = false(size(handles.masks,1),size(handles.masks,2));
            % Subtitute the subset for the result
            mask(handles.keepx,handles.keepy)=minimask;
        end

        handles = cprof_addpair( handles,mask,2,ind );
    end
end

