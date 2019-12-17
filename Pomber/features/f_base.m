classdef f_base < handle
    %FEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        f
    end
    
    methods
        %% Constructor and related
        function obj = f_base(c)
            obj.name = '';
        end
        %% Finding and correcting
        function find(self,cut_video,cell_masks,im_info,which_i,extra)
        end
        function draw(self,cut_video,x_bound,y_bound,which_i,contrast,cut_extra)
        end
         %% Functions called after the feature is found
        function postProcess(self,cut_video,cell_masks)
        end
        function measureIntensity(self,cut_video,cell_masks)
        end
        %% Export
        function export(self,dir_sp,time,im_info)
        end
        %% Display
        function displayCloseup(self,i,x_lims,y_lims,transposing)
        end
        function extraplot(obj,name,iscurrent,tpoint,category)
        end
        function displayBigIma(obj, which_i,rows,cols,sizes,x0,y0,transposing)
        end
    end
end