function [ handles ] = pom_again( handles )
    
    barry = waitbar(0,'Repeating the analysis of cells');
    nb_cells = numel(handles.cells) ;
    for i = 1:nb_cells
        waitbar(i/nb_cells)
        handles.cells{i} = handles.cells{i}.update_analysis(handles.im_info);
        
%         for j = 3:5
%             channel = find(handles.an_type==j);
%             if numel(channel)==1
%                 handles.cells{i}=pom_anany(handles.cells{i},channel,j,2,handles.im_info.resolution,handles.im_bg(:,channel));
%             end
%         end
    end
    close(barry)
%    [ handles ] = update_ints( handles );
end

