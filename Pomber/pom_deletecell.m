function [ handles ] = pom_deletecell( handles )
    
    % Delete the cell
    handles.cells(handles.currentcell) = [];
    % Circular indexing
    %wrapN = @(x) (1 + mod(x-1, numel(handles.cells)-1));
    
    [ handles ] = update_frame_list( handles );

    handles.currentcell = 0;
    
    dummy = numel(handles.video)/2;
    for j = 1:(dummy*2)
        axes(handles.(['ax_closeup' num2str(j)]))
        hold off
        cla
    end
end

