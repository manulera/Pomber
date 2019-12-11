function [handles] = pom_load_extra(handles)

    
    folder = [handles.pathfile filesep 'extra'];
    
    if ~isfolder(folder)
        % If the video initially had drift applied and the file can be no
        % longer found
        warndlg({'No "extra" directory:', folder})
        return
    end
    
    files = dir(folder);
    regex_value = [handles.pos_name '_wave_(\d)_(.*)_extra\.tif'];
    for i = 1:numel(files)
        name = files(i).name;
        [mat,tok,~]=regexp(name,regex_value,'match','tokens','tokenExtents');
        if ~isempty(mat)
            handles.extra_loaded=true;
            channel = str2double(tok{1}{1});
            handles.extra{channel}=readTiffStack([folder filesep name]);
        end
    end
    
    if handles.extra_loaded==false
        warndlg({['No extra file for ' handles.pos_name]})
    end
    
end

