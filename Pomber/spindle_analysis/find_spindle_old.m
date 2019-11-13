function [x,y,cont,spinmask] = find_spindle_old( ima ,prev_length,resolution)
    if prev_length < 4
        spinmask = find_spindle_thresh(ima);
        cont = bwboundaries(spinmask);
        
        if ~isempty(cont)
            cont = cont{1};
        else
            cont = [];
        end
    
        [ y,x ] = mask2line( spinmask,ima,resolution );
    else
        spinmask = zeros(size(ima));
        cont = [];
        [y,x] = find_spindle_max(ima,resolution);
    end
end

