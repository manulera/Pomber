function [h] = pom_load_drift(h)
    
    folder = [h.pathfile filesep 'drifts'];
    if ~isfolder(folder)
        warndlg({'No "drifts" directory:', folder})
        return
    end
    target = [folder filesep h.pos_name '.txt'];
    
    if ~isfile(target)
        warndlg({['No drift file for ' h.pos_name]})
        
        return
    end
    drift = read_drift_file(target);
    for i = 1:numel(h.video)
        h.video{i} = apply_drift(h.video{i},drift);
    end
    h.drift_applied = true;
end
