classdef cellu < handle
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
        % features
        features
        % For each channel, which kind of analysis has been done (default
        % is 1, which corresponds to none)
        
    end
    methods
        
        function self = cellu(input)
            
            % Create an empty cell, which only includes the masks of the
            % cell.
            self.masks = input.masks;
            self.list = input.list;
%             ones(1,numel(handles.an_type))
        end
        
        
        
    end
end

