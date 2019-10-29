function [microsc_files,microsc_info] = MetamorphRegex(path,ndfile)
    
    [~,basename] = fileparts(ndfile);
    reg = [basename '_w(\d)(\d).*_s(\d*)_t(\d*)\.TIF'];
    microsc_files = {};
    microsc_info = [nan nan nan];
    files = dir(path);
    for i = 1:numel(files)
        name = files(i).name;
        [mat,tok,~] = regexp(name, reg, 'match', ...
               'tokens', 'tokenExtents');
        if ~isempty(mat)
            tok=tok{1};
            microsc_files = [microsc_files mat{1}];
            microsc_info = [microsc_info; [str2double(tok{1}) str2double(tok{3}) str2double(tok{4})]];
        end
    end
    microsc_info(1,:)=[];
end

