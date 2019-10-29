function [ out ] = cprof_done( handles )
    
% In principle from the output you should be able to restore the whole
% figure, maybe this is not the most efficient but I keep all the
% variables.
f = fields(handles);
% All the variable types we dont want to store (old)
%exclude = {'matlab.ui.Figure','matlab.ui.control.UIControl','matlab.graphics.axis.Axes','matlab.ui.Figure'};
out = struct();
for i = 1:numel(f)
    name = f{i};
    
    % restore is now useless, and video can be regenerated if needed, so no
    % need to store it.
    % BEFORE: strcmp(class(handles.(name)),exclude)
    
    if ~strncmp('matlab.',class(handles.(name)),7) && ~any(strcmp(name,{'restore','video'}))
        out.(name) = handles.(name);
    end
    
end

% Make the short video that eventually will be saved as a file and also
% used for the analysis.
out.video = cell(1,numel(handles.video));
for i = 1:numel(handles.video)
    out.video{i} = handles.video{i}(:,:,handles.list,:);
end
end

