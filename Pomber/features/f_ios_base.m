classdef f_ios_base < f_base
    %FEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % The spindle object this refers to (a reference I guess)
        spindle_feature
        
        % The background
        bg
        
        % Total intensity along the spindle
        tot_int
        
        % Intensity profile (all_lines)
        int
        
        % Fit of the signal to a Gaussian
        fit
        
        % Intensity profile summed
        int_summed
        
    end
    
    methods
        %% Constructor and related
        function obj = f_ios_base(c)
            obj.name = 'ios_base';
            obj.clear(c);
        end
        function clear(obj,c)
            tpoints = numel(c.list);
            
            obj.int = cell(1,tpoints);
            obj.int_summed = cell(1,tpoints);
            
            obj.tot_int = zeros(1,tpoints);

            obj.bg = zeros(1,tpoints);
            obj.fit = zeros(tpoints,4);
            
            found = 0;
            for i = 1:numel(c.features)
                if isempty(c.features{i})
                    continue
                end
                if strcmp(c.features{i}.name,'spindle')
                    obj.spindle_feature = c.features{i};
                    found = found + 1;
                end
            end
            
            if found~=1
                errordlg(['Intensity on Spindle (ios) feature failed to initialize. ' ...
                    num2str( found ) ' spindle features found in one cell'
                ])
            end
        end
        %% Finding and correcting
        function find(self,cut_video,cell_masks,im_info,which_i,probs) 
            % Nothing
        end
        
        function draw(self,cut_video,x_bound,y_bound,which_i,contrast,cut_extra)
            % Nothing
        end
        
        
        function postProcess(self,cut_video,cell_masks,indexes2analyze)
            % Nothing 
        end
        
         %% Functions called after the feature is found
        function measureIntensity(self,cut_video,cell_masks,indexes2analyze)
            
            if nargin<4||isempty(indexes2analyze)
                indexes2analyze = 1:numel(self.spindle_feature.spind);
            end
                
            for i = indexes2analyze
                
                % Background calculation and substraction
                ima = cut_video(:,:,i);
                mask = cell_masks(:,:,i);
                self.bg(i) = image_background(ima(mask));

                x = self.spindle_feature.spind{i}(:,1);
                y = self.spindle_feature.spind{i}(:,2);
                sp_fit = self.spindle_feature.spindle_trace_fit(i,:);
                
                [self.int{i},self.tot_int(i)] = spindleLinescan(x,y,sp_fit,ima);
                self.int_summed{i} = multiple2SingleImprofile(self.int{i},defaultSpindleParameters());
                
                x = 1:numel(self.int_summed{i});
                y = self.int_summed{i};
                sugg = [max(y),numel(y)/2,5,min(y)];
                self.fit(i,:) = OLSfit(x,y,@gaussian,sugg,'Robust');
                
            end
            
        end
        %% Export
        function export(self,dir_sp,time,im_info)
        end
        %% Display
        function extraplot(obj,this_axis,name,iscurrent,tpoint,category)
        switch name
        % Spindle
        case 'IOS: intensity profile'
            
            if ~iscurrent
                return
            end
            
            int_curve = multiple2SingleImprofile(obj.int{tpoint},defaultSpindleParameters());
            extraplot_profile(this_axis,{int_curve},iscurrent,1)
            
            x = 1:numel(int_curve);
            hold(this_axis,'on')
            
            plot(this_axis,x,gaussian(x,obj.fit(tpoint,:)))
            
        case 'IOS: Spindle length vs.total intensity'
            extraplot_many(this_axis,obj.tot_int,iscurrent,tpoint,obj.spindle_feature.len,category)
        end
        end
        
        function displayCloseup(self,this_axis,i,x_lims,y_lims,transposing)

            hold on
            [xx,yy]=self.spindle_feature.spindleParallelCurves(i);
            xx = xx-x_lims(1)+1;
            yy = yy-y_lims(1)+1;
            
            color = 'red';
            xx = xx([1,end],:);
            yy = yy([1,end],:);

            if ~transposing
                plot(this_axis,xx',yy',color,'LineWidth',2)
            else
                plot(this_axis,yy',xx',color,'LineWidth',2)
            end
            
        end
        
        function displayBigIma(self, which_i,rows,cols,sizes,x0,y0,transposing)
            % Nothing
        end
    end
end