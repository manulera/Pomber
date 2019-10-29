function [ handles ] = pom_movecell( handles,move )
    
    % Old method
%     list = handles.frame_list{handles.currentt};
%     if ~isempty(list)
%         i_logic = handles.currentcell==list;
% 
%         % Circular indexing
%         wrapN = @(x) (1 + mod(x-1, numel(list)));
% 
%         if any(i_logic)
%             i = find(i_logic);
%             handles.currentcell = wrapN(i+move);
%         else
%             handles.currentcell = list(1);
%         end
%     end
    if handles.tog_fastscroll.Value
        return
    end
    % I figured out it would be better to just move to the first frame of
    % the next cell in the list.
    wrapN = @(x) (1 + mod(x-1, numel(handles.cells)));
    handles.currentcell = wrapN(handles.currentcell+move);
    % Switch the video to the current position 
    handles.currentt = handles.cells{handles.currentcell}.list(1);
    set(handles.slider_t,'Value',handles.currentt);
    % Update the cell slider
    tot = numel(handles.cells{handles.currentcell}.list);
    set(handles.pop_condition_type,'Value',handles.cells{handles.currentcell}.mitmei+1);
    set(handles.slider_cell,'Max',tot);
    set(handles.slider_cell,'Min',1);
    set(handles.slider_cell,'Value',1);
    set(handles.slider_cell,'SliderStep',[1, 1]/(tot-1));
end

