function [  ] = print_csv_cell( dirname,name,data,r,ext )
    
    % Folder with the values in pixels
    dir_pix = [dirname filesep 'in_pix'];
    if ~isdir(dir_pix)
        mkdir(dir_pix)
    end
    pref1 = [dir_pix filesep name];
    pref2 = [dirname filesep name];
    names = {[pref1 '_pix' ext] [pref1 '_col_pix' ext] [pref2 '_um' ext] [pref2 '_col_um' ext]};
    for i =1:4
        if exist(names{i},'file')
            delete(names{i})
        end
    end
    nb_tpts = numel(data{1});% This is time so it should be the same in both
    n_data = numel(data);
    
    for i = 1:2
        big_cell = cell(1,nb_tpts*n_data);
        f_rows = names{2*i-1};
        f_cols = names{2*i};
        for t = 1: nb_tpts
            for j = 1:n_data
                d = data{j}{t};
                dlmwrite(f_rows, r(2*(i-1)+j)*d', '-append')
                %dlmwrite(f_rows, r(2*i)*data{2}{t}', '-append')
                for k = 1:size(d,2)
                    big_cell{2*(t-1)+j+(k-1)} = r(2*(i-1)+j+(k-1))*d(:,k);
                end
            end

        end
        big_cell = rows_2emptycols(big_cell);
        dlmcell(f_cols,big_cell)
    end

end

