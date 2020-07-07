function [  ] = pom_save( handles )
% Save the figure to keep working on it later

%% Create a structure containing relevant variables
f = fields(handles);

% All the variable types we dont want to store
exclude_class = {'matlab.ui.Figure','matlab.ui.control.UIControl','matlab.graphics.axis.Axes','matlab.ui.Figure'};
% Exclude also certain variables we dont want to store like the video and
% the extra
exclude_name = {'video','extra','sum_video','current_cell_rp','small_video'};

out = struct();
for i = 1:numel(f)
    name = f{i};    
    if ~any(strcmp(class(handles.(name)),exclude_class)) && ~any(strcmp(name,exclude_name))
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
