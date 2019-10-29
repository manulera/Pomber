classdef cellu2 < handle
    %CELLU The cell object
    
    properties
        % An object [x_size,y_size,t_size] with the masks of the cell
        masks
        % A list of the time frames in which the cell is present
        list
        % Contour of the cell in the small video
        cont
        % Whether it is the current cell.
        current
        % You can assign several categories here
        mitmei
        % The edges of the box to crop the video
        ini_box
        % features
        features
        xlims
        ylims
        sp
        dots
        ios
        
    end
    methods
        function self = cellu2(ima)
            [x,y] = getpts();
            if numel(x)~=2
                return
            end
            [ima_cropped,self.xlims,self.ylims] = pom_pre_crop_cell(ima,y,x);
            [ cropped_mask ] = draw_cell( ima_cropped);
            self.masks = false(size(ima));
            self.masks(self.xlims,self.ylims) = cropped_mask;
        end
     
        
    end
end

