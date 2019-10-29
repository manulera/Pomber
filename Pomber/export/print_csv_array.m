function [  ] = print_csv_array( dirname,name,data,r,ext )
    % Folder with the values in pixels
    if numel(r)~=size(r,2)
        error('Wrong format of resolution and data')
    end
    dir_pix = [dirname filesep 'in_pix'];
    if ~isdir(dir_pix)
        mkdir(dir_pix)
    end
    pref1 = [dir_pix filesep name];
    pref2 = [dirname filesep name];
    names = {[pref1 '_pix' ext], [pref2 '_um' ext]};
    
    dlmwrite(names{1},data)
    for i = 1:size(data,2)
        data(:,i) = data(:,i)*r(i);
    end
    dlmwrite(names{2},data)
    
end

