function [out] = read_drift_file(file_name)
    
    fid = fopen(file_name);

    % Skip four lines
    for i = 1:4
        fgetl(fid);
    end
    
    tline = fgetl(fid);
    out = [];
    while ischar(tline)
        values = sscanf(tline,'%f\t%f\t%f');
        if ~isempty(values)
            out = [out values];
        end
        tline = fgetl(fid);

    end
    fclose(fid);
    out = ceil(out);
end

