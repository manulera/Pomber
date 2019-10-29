function [ima_long,conts,x_box,y_box,transposing] = cprof_make_imalong(video,list,masks)
    
    channels = numel(video);
    ima_long = cell(channels);
    
    abs_mask =any(masks,3);
    [x_box,y_box] = expandBoundingBox(abs_mask,0.7);
    
    if numel(x_box)<numel(y_box)
        transposing=true;
    else
        transposing=false;
    end
    
    for i = 1:channels
        ima_long{i}=[];
        for j = list
            ima = video{i}(y_box,x_box,j);
            if ~transposing
                ima_long{i} = cat(1,ima_long{i},ima);
            else
                ima_long{i} = cat(1,ima_long{i},ima');
            end
        end
    end
    
    conts = cell(size(masks,3));
    for i = 1:size(masks,3)
        cont = bwboundaries(masks(y_box,x_box,i));
        conts{i}=cont{1};
    end
    
end