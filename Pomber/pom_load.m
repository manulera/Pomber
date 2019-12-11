function [ handles ] = pom_load(handles,path,file)
    
if nargin==1
    % Locate save file
    [file, path] = uigetfile('*.mat','Locate the .mat file of saved data');
end
if file==0
    return
end
load([path filesep file])

% Copy all the fields from out
f = fields(out);
for i = 1:numel(f)
    handles.(f{i}) = out.(f{i});
end

handles = pom_updater(handles);
% Maybe they have moved the whole directory somehwere else, so we want to
% keep the current position of the .mat file, which should be ../../ from
% this one
bounds = strfind(path,filesep);
handles.pathfile = path(1:bounds(end-2));
% Load the video again, I think its better to load it manually,
% since otherwise you may change the location of the data.
[ handles ] = pom_import( handles,0 );

if handles.extra_loaded
    handles = pom_load_extra(handles);
end

if handles.drift_applied
    handles.video = pom_load_drift(handles,handles.video);
    handles.sum_video = pom_load_drift(handles,handles.sum_video);
    if handles.extra_loaded
        handles.extra = pom_load_drift(handles,handles.extra);
    end
end

% This is just to update the slider on the right when you load the cell
[ handles ] = pom_movecell( handles,0 );
% Restore the positions of the pop_menus
if numel(handles.video)==2
    lim_an = 2;
elseif numel(handles.video)>2
    lim_an = 3;
end

for i = 1:lim_an
    set(handles.(['pop_c' num2str(i)]),'Value',handles.an_type(i))
end