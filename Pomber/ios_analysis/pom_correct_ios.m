function [ c ] = pom_correct_ios( c,channel,i )
    ima = c.video{channel}(:,:,i).*c.masks(:,:,i);
    figure
    imagesc(ima)
    axis equal
    % Mark points
    [x,y] = getpts();
    % Project them on the line
    if ~isempty(x)
        line = c.sp.spind{i};
        for j = 1:numel(x)
            % Calculate a matrix of distances of the pixels to the 
            all_dis = [line(:,2) - x(j), line(:,1) - y(j) ];
            all_dis = sum(all_dis.^2,2);
            % Get the indexes of the minimum distance
            [~,ind] = min(all_dis,[],1);
            % Incorporate the index to the edge
            if ind<=size(line,1)/2
                c.ios.edges(1,i) = ind;
            else
                c.ios.edges(2,i) = ind;
            end
            
        end
    end
    close
end

