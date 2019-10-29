function [ out ] = cell_nan2empty( out )

for i = 1:numel(out)
    if isnan(out{i})
        out{i} = '';
    else
        out{i} = num2str(out{i});
    end
end

end

