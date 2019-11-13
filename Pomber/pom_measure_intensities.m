function [handles] = pom_measure_intensities(handles)
    % Make a sum projection of the movie
    sum_video = readMetamorphNd(handles.pathfile, handles.ndfile,'sum',handles.pos_name);
    
    if handles.drift_applied
        sum_video = pom_load_drift(handles,sum_video);
    end
    
    for i = 1:numel(handles.cells)
        handles.cells{i}.measureIntensity(sum_video);
    end
    
end

