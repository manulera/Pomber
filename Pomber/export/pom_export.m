function [ ] = pom_export( handles )
    
    % Check if directory exists
    % Check if directory exists
    dirname = [handles.pathfile filesep 'pomber_analysis'];
    if ~isdir(dirname)
        mkdir(dirname)
    end
    dirname = [dirname filesep handles.pos_name];
    if ~isdir(dirname)
        mkdir(dirname)
    end
    
    % These are column variables
    dlmwrite([dirname filesep 'master_time.txt'],handles.time(:), 'delimiter', ',')
    
    % Print the resolution to a file if provided
    if ~isnan(handles.im_info.resolution)
        dlmwrite([dirname filesep 'resolution.txt'],handles.im_info.resolution(:), 'delimiter', ',')
    end
    % Create a variable with the channel names and the channel analysis
    channels = numel(handles.channel_names);
    c_an = cell(channels,1);
    for i = 1:channels
       c_an{i} = handles.pop_c1.String{handles.an_type(i)};
    end    
    
    dlmcell([dirname filesep 'channel_names.txt'], [handles.channel_names' c_an])
    if ispc
        dlmcell([dirname filesep 'original_path.txt'],{process_path_pc(handles.pathfile)})
    else
        dlmcell([dirname filesep 'original_path.txt'],{handles.pathfile})
    end
    % Save information of each cell
    barry = waitbar(0,'Exporting cells');
    nb_cells = numel(handles.cells);
    
    for i = 1:nb_cells
        waitbar(i/nb_cells)
        handles.cells{i}.export(handles,[dirname filesep 'cell_' sprintf('%04d',i)])
%         pom_export_cell(handles.cells{i},[dirname filesep 'cell_' sprintf('%04d',i)],handles)
    end
    close(barry)
end