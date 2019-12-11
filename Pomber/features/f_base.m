classdef f_base < handle
    %FEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        f
    end
    
    methods
        %% Constructor and related
        function obj = f_base()
            obj.name = '';
        end
        
        function find(varargin)
            
        end
        function obj = copy(obj,i_this,other,i_other)
        end
        function obj = draw(obj,c,channel,im_info,which_frames)
        end
        function obj = postProcess(obj,c,channel,im_info)
        end
        %% Correction/update
        function obj = update(obj,c,channel,im_info)
        end
        function obj = correct(obj,c,channel,t,im_info) 
        end
        function obj = keep(obj,id_keep)
        end
        function obj = add_frames(obj,c,channel,im_info,add_bef,add_aft)
        end
        function obj = correct_onstack(obj,c,channel,time,im_info,filename)
        end
        %% Export
        function export(obj,dir_dots,time,im_info )
        end
        %% Display
        function display_closeup(obj,i)
        end
        function extraplot(obj,name,iscurrent,tpoint,category)
        end
        %% Remove some frames
        function obj = remove_frames(obj,frames)
            obj.f(frames) = [];
        end
        
    end
end