function [ima,to_remove] = pipe_remove_small_regionprops(ima,thresh)
% Takes a binary image and removes the regions smaller than thresh

s = regionprops(ima,'Area');
ima_lab = bwlabel(ima);
to_remove = find([s.Area]<thresh);

for i = to_remove
    ima(ima_lab==i)=0;
end

end

