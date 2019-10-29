function [ handles ] = cprof_addpair( handles,mask,mode,ind )
    if nargin<4
        ind = 0;
    end
    cont = bwboundaries(mask);
    cont = cont{1};
    
    if mode==0
        % Add previous
        handles.masks = cat(3,mask,handles.masks);
        handles.cont = [cont handles.cont];
    
    elseif mode==1
        % Add next
        handles.masks = cat(3,handles.masks,mask);
        handles.cont = [handles.cont cont];
        
    elseif mode==2 && ind
        % Substitute
        handles.masks(:,:,ind) = mask;
        handles.cont{ind} = cont;
    end
    
end

