function [ handles ] = cprof_addpair( handles,mask,mode,ind )
    if nargin<4
        ind = 0;
    end
    if mode==0
        % Add previous
        handles.masks = cat(3,mask,handles.masks);
    elseif mode==1
        % Add next
        handles.masks = cat(3,handles.masks,mask);
        
    elseif mode==2 && ind
        % Substitute
        handles.masks(:,:,ind) = mask;
    end
    
end

