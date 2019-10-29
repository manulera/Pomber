function [alli] = select_from_big_ima(ro,co,rows,cols,sizes)
    
    % Convert the coordinates into the index of the images selected
    ro = floor((ro-1)/sizes(1))+1;
    co = floor((co-1)/sizes(2))+1;
    alli = sub2ind([rows,cols],ro,co);
    
    % In case you click twice on the same one
    alli = unique(alli); 
end