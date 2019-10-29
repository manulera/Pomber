function [microsc_files,microsc_info] = MetamorphRegex(path,ndfile)
    
    [~,basename] = fileparts(ndfile);
    % *? makes the asterisk match as least characters as possible (not to
    % match the _ character in the group _s)
    reg = [basename '(_w\d\d)?.*?(_s\d*)?_(t\d*)?\.TIF'];
    extract = {'_w%1d','_s%d','t%d'};

    microsc_files = {};
    microsc_info = [];
    files = dir(path);
    for i = 1:numel(files)
        name = files(i).name;
        [mat,tok,~] = regexp(name, reg, 'match', ...
               'tokens', 'tokenExtents');
        if ~isempty(mat)
            tok=tok{1};
            microsc_files = [microsc_files mat{1}];
            info = [1 1 1];
            for j = 1:numel(tok)
                if ~isempty(tok{j})
                    info(j) = sscanf(tok{j},extract{j});
                end
            end
            microsc_info = [microsc_info; info];
        end
    end
    microsc_info = [microsc_info(:,1) microsc_info(:,2) microsc_info(:,3)];
end

