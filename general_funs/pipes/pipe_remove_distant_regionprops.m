function [ima,to_remove] = pipe_remove_distant_regionprops(ima,thresh)
% Takes a binary image and removes the regions which are at a distance
% smaller than thresh to their closer neighbour

s = regionprops(ima,'Centroid');
cents = [s.Centroid];
x = cents(1:2:end);
y = cents(2:2:end);
len = numel(x);
all_dis = nan(len);
for i = 1:len
    all_dis(i,:) = (x-x(i)).^2 + (y-y(i)).^2;
end
all_dis(all_dis==0)=nan;

min_dis = nanmin(all_dis);
ima_lab = bwlabel(ima);



to_remove = find(min_dis>thresh^2);

for i = to_remove
    ima(ima_lab==i)=0;
end

end

