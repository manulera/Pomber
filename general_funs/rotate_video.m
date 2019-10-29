function [ v2 ] = rotate_video( v,xlims,ylims,angle )
    % v must be a cell array containing the array of each channel
    v2 =cell(1,numel(v)); 
    for i = 1:numel(v)
        % Take the first frame and turn it to get the dimensions of the
        % video
        frame1 = v{i}(:,:,1,1);
        frame1 = rotate_ima( frame1,angle,[],xlims,ylims );
        dims = size(frame1);
        % GEneral so that it also works for the merge channel
        v2{i} = nan(dims(1),dims(2),size(v{i},3),size(v{i},4));
        ind = 1;
        for t = 1:size(v{i},3)
            if i~=4
                v2{i}(:,:,ind) = rotate_ima(v{i}(:,:,t),angle,[],xlims,ylims );
            else
               ima = [];
               for j = 1:3
                    ima_j = rotate_ima(squeeze(v{i}(:,:,t,j)),angle,[],xlims,ylims );
                    ima = cat(4,ima,ima_j);
               end
               v2{i}(:,:,ind,:) = ima;
            end
            ind = ind+1;
        end
    end
end

