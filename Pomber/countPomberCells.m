function [] = countPomberCells(folder)
    % [] = count_pomber_cells(folder)
    % Count the number of cells in each pomber_save folder
    
    if nargin<1||isempty(folder)
        folder = '.';
    end
    found = dir(fullfile(folder, ['**' filesep 'pomber_save.mat']));
    
    for i = 1:numel(found)
        load([found(i).folder filesep  found(i).name])
        nb_cells = numel(out.cells);
        position_name = split(found(i).folder,filesep);
        position_name = position_name{end};
        fprintf("%s --> %u cells\n",position_name,nb_cells);
        count_mitmei = 0;
        for j = 1:nb_cells
            count_mitmei = count_mitmei + out.cells{j}.mitmei~=0;
        end
        
        fprintf("  --> %u special found\n",count_mitmei);
        
    end
    
end

