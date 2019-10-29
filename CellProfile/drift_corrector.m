function [xx,yy] = drift_corrector(this,other)

vals = nan(11,11);
move =-15:3:15;
edges = 30;

midx = round(size(other,1)/2);
midy = round(size(other,2)/2);
xlim = (midx-edges):(midx+edges);
ylim = (midy-edges):(midy+edges);

for xx = 1:11
    for yy = 1:11
        mat = (other(xlim,ylim) - this(xlim+move(xx),ylim+move(yy))).^2;
        vals(xx,yy) = sum(mat(:));
    end
end
[value, index] = min(vals(:));
[xx, yy] = ind2sub([11,11], index);
xx = -move(xx);
yy = -move(yy);


end

