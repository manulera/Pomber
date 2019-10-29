function [out] = get_time_frommeta(metadata)
    metadata = splitlines(metadata);
    for i = 1:numel(metadata)
        % Remove initial spaces. Apparently some versions of metamorph
        % added before the fields of metadata (indentation)
        data_str = strtrim(metadata{i});
        if numel(data_str)>33 && strcmp(data_str(1:33),'<prop id="acquisition-time-local"')
            out = split(data_str);
            time = out{end}(1:end-3);
            date = out{end-1}(8:end);
            out = datetime( [ date ' ' time(1:8)],'InputFormat', 'yyyyMMdd HH:mm:ss' );
        end
    end
end

