function [h] = pom_load_categories(h,select_file)
    if select_file
        [file, path] = uigetfile('*.txt','Find the categories file');
        file_name = [path filesep file];
    else
        dirname = [h.pathfile filesep 'pomber_analysis'];    
        file_not_found = true;
        if isdir(dirname)
            dirname = [dirname filesep h.pos_name];
            if isdir(dirname)
                file_name = [dirname filesep 'categories.txt'];
                if isfile(file_name)
                    file_not_found = false;
                end
            end
        end
        if file_not_found
            return
        end
    end
    
    fid = fopen(file_name);
    
    tline = fgetl(fid);
    cats = {'none'};
    while ischar(tline)
        cats = [cats tline];
        tline = fgetl(fid);
    end
    fclose(fid);
    h.pop_condition_type.String = cats';
    h.pop_condition_type.Value = 1;
    
    if select_file
        % Check if directory exists
        dirname = [h.pathfile filesep 'pomber_analysis'];    
        if ~isdir(dirname)
            mkdir(dirname)
        end
        
        dirname = [dirname filesep h.pos_name];
        if ~isdir(dirname)
            mkdir(dirname)
        end
        copyfile(file_name,[dirname filesep 'categories.txt']);
    else
        fprintf('Loaded a categories file\n');
    end
end

