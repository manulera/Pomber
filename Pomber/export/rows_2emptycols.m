function [ out ] = rows_2emptycols( c )

lens = sum(cellfun('length',c),1);
out = nan(max(lens),numel(lens));
out(bsxfun(@le,[1:max(lens)]',lens)) = vertcat(c{:});
out = num2cell(out);
[ out ] = cell_nan2empty( out );


end

