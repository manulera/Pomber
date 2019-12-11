function [ handles ] = pom_again( handles )
    
    barry = waitbar(0,'Repeating the analysis of cells');
    nb_cells = numel(handles.cells) ;
    for i = 1:nb_cells
        waitbar(i/nb_cells)
        handles.cells{i}.update_analysis(handles.video,handles.sum_video);
    end
    close(barry)
end

