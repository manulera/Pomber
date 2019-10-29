function [handles] = pom_init( handles ,skip_position)

if nargin<2
    skip_position = false;
end
% In case you want to load another position of the same video
if ~skip_position
    handles.pos_name = '';
    handles.all_pos_names = {};
end
handles.drift_applied=false;
handles.toggled = 1;
handles.cells = {};
handles.currentcell = 0;
set(handles.tog_c1,'Value',1)
handles.currentt = 1;
handles.squares = {};
handles.version = '2.0';
end

