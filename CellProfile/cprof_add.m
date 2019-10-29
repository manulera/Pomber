function [ handles ] = cprof_add( handles,isnext )

skip = false;

if isnext
    current = max(handles.list);
    next = current +1;
    prev_mask = size(handles.masks,3);
    if next>handles.size(3)
        skip = true;
    else
        handles.list = [handles.list next];
    end
    handles.current = 1;
else
    current = min(handles.list);
    next = current -1;
    prev_mask = 1;
    if next<1
        skip = true;
    else
        handles.list = [next handles.list];
    end
    handles.current = numel(handles.list)-handles.limshow + 1;
end

if ~skip
    
    ima = handles.video{handles.dic}(:,:,next);
    % Small number of iterations in hope that it will only adapt to the
    % local environment
    iter = 20;
    switch handles.popupmenu1.Value
        case 1 % Copy
%             prev_ima = handles.video{handles.dic}(:,:,current);
%             [x_corr,y_corr] = drift_corrector(prev_ima,ima);
%             prev_cont = handles.cont{prev_mask};
%             prev_cont(:,1) = prev_cont(:,1) + x_corr;
%             prev_cont(:,2) = prev_cont(:,2) + y_corr;
%             mask = poly2mask(prev_cont(:,2),prev_cont(:,1),size(ima,1),size(ima,2));
            % Just copy
            mask = handles.masks(:,:,prev_mask);
        case 2 % Propagate
        if ~handles.omit
            cont = resamplePolyline(handles.cont{prev_mask},200);
            [ ~,mask ] = grow_cell( ima,cont,iter );
        else
            mask = handles.masks(handles.keepx,handles.keepy,prev_mask);
            cont = bwboundaries(mask);
            cont = cont{1};
            cont = resamplePolyline(cont,200);
            [ ~,minimask ] = grow_cell( ima(handles.keepx,handles.keepy),cont,iter );
            % A black mask
            mask = false(size(handles.masks,1),size(handles.masks,2));
            % Subtitute the subset for the result
            mask(handles.keepx,handles.keepy)=minimask;
        end
            
    end
    handles = cprof_addpair( handles,mask,isnext );
    
end
end

