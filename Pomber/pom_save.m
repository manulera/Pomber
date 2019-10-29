function [  ] = pom_save( handles )
% Save the figure to keep working on it later

%% Create a structure containing relevant variables
f = fields(handles);
% All the variable types we dont want to store
exclude = {'matlab.ui.Figure','matlab.ui.control.UIControl','matlab.graphics.axis.Axes','matlab.ui.Figure'};
out = struct();
for i = 1:numel(f)
    name = f{i};    
    % No point in saving the video, it can be restored from the original
    % data if its in the same place
    if ~any(strcmp(class(handles.(name)),exclude)) && ~any(strcmp(name,{'video'}))
        out.(name) = handles.(name);
    end
end

%% Make the directory to store the analysis

% Check if directory exists
dirname = [out.pathfile filesep 'pomber_analysis'];
if ~isdir(dirname)
    mkdir(dirname)
end
dirname = [dirname filesep out.pos_name];
if ~isdir(dirname)
    mkdir(dirname)
end

% Save handles
save([dirname filesep 'pomber_save.mat'],'out')
warndlg('Data saved')
