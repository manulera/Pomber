function [ ima2 ] = maximal_proj( ima, dim )
% Make the maximal projection on the dimension dim

ima2 = max(ima,[],dim);

end

