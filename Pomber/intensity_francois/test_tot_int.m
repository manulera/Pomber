% list is a structure with cell objects
% fluo is the fluorescence video as an array (x,y,t)
% Channel of tubulin 
channel = 3;
figure
for substract_cell_bg = [0,1]
subplot(2,1,substract_cell_bg+1)

hold on
    
for j = 1:numel(list)
    % A cell object
    c = list{j};
    
    times = numel(c.list);
    
    % Length of the spindle
    c.sp.len = zeros(1,times);

    % Distance between the poles, could be used compared with the length to get
    % the buckling
    c.sp.dist = zeros(1,times);

    % Intensity of tubulin along the spindle (Intensity profile)
    c.sp.int = cell(1,times);
    
    % Radio of intensity on the spindle vs. intensity of the cytoplasm
    c.sp.r_spindle = zeros(1,times);

    % Background of intensity;
    c.sp.bg = nan(1,times);
    
    for i = 1:times
        % From the fluorescence image, get the background (this is a
        % function used in the paper)
        im_bg = image_background(fluo(:,:,c.list(i)));
        
        s = c.sp.spind{i};
        % In case you get a very small spindle -a dot-, you could get its length 0
        if ~isempty(s)
            c.sp.dist(i) = sqrt(sum((s(1,:)-s(end,:)).^2));
            c.sp.len(i) = sum(sqrt(sum(diff(s).^2,2)));
            
            % We resample the line so that it has as many points as pixel length
            % to prevent oversampling
            s2 = resamplePolyline(s,ceil(c.sp.len(i)));
            
            % A mask containing the cell
            cell_mask = c.masks(:,:,i);
            
            % The cropped image of the cell in the tubulin channel
            % with the background substracted
            ima = c.video{channel}(:,:,i)-im_bg;
            
            % Intensity profile along the spindle
            [c.sp.int{i},spind_mask] = thicc_profile(ima,s2(:,2),s2(:,1),3);
            
            % Mask containing the area where the intensity of the spindle
            % is measured
            in_mask = spind_mask.*cell_mask;
            % Mask containing the surface of the cell without the spindle
            out_mask = ~spind_mask.*cell_mask;
            
            % How to calculate the background??
            bgg = ima.*out_mask;
            c.sp.bg(i) = median(bgg(bgg~=0));
            
            bg_mask = ima>c.sp.bg(i);
            if substract_cell_bg
                ima = ima-c.sp.bg(i);
            end
            
            % Intensity inside in_mask
            in_int = sum(sum(ima.*in_mask.*bg_mask));
            % Intensity inside out_mask
            out_int= sum(sum(ima.*out_mask.*bg_mask));
            
            % Ratio in/ out
            c.sp.r_spindle(i) = in_int/out_int;
            
        else
            c.sp.int{i} = 0;
            c.sp.r_spindle(i) = 0;
        end
    end

    scatter(c.sp.len*0.16,c.sp.r_spindle)
end
end