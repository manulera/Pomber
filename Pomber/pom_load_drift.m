function [video] = pom_load_drift(h,video)
    
    folder = [h.pathfile filesep 'drifts'];
    
    if ~isfolder(folder)
        % If the video initially had drift applied and the file can be no
        % longer found
        warndlg({'No "drifts" directory:', folder})
        return
    end
    target = [folder filesep h.pos_name '.txt'];
    
    if ~isfile(target)
        % If the video initially had drift applied and the file can be no
        % longer found
        warndlg({['No drift file for ' h.pos_name]})
        return
    end
    
    drift = read_drift_file(target);
    for i = 1:numel(video)
        if ~isempty(video{i})
           video{i} = apply_drift(video{i},drift);
        end
    end
    
    
end
