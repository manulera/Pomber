classdef f_ios < f_base
    %FEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % The spindle object this refers to (a reference I guess)
        spindle_feature
        
        % The background
        bg
        
        % Total intensity along the spindle
        tot_int
        
        % Midzone intensity
        midz_int
        
        % Midzone tubulin intensity
        midz_tub
        
        % Intensity profile (all_lines)
        int
        
        % Fit of the signal to a Gaussian
        fit
        
        % Intensity profile (only the center)
        int_summed

        
    end
    
    methods
        %% Constructor and related
        function obj = f_ios(c)
            obj.clear(c);
        end
        function clear(obj,c)
            obj.name = 'ios';
            tpoints = numel(c.list);
            
            obj.int = cell(1,tpoints);
            obj.int_summed = cell(1,tpoints);
            
            obj.tot_int = zeros(1,tpoints);
            obj.midz_int = zeros(1,tpoints);
            obj.midz_tub = zeros(1,tpoints);
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
        
         %% Functions called after the feature is found
        function measureIntensity(self,cut_video,cell_masks)
            
            for i = 1:numel(self.spindle_feature.spind)
                
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
                
                edges = self.getEdges(i);
                self.midz_int(i) = sum(self.int_summed{i}(edges(1):edges(2)));
                self.midz_tub(i) = sum(self.spindle_feature.int_summed{i}(edges(1):edges(2)));
                
            end
        end
        %% Export
        function export(self,dir_sp,time,im_info)
        end
        %% Display
        function extraplot(obj,name,iscurrent,tpoint,category)
        
        switch name
        % Spindle
        case 'IOS: intensity profile'
            if ~iscurrent
                return
            end
            
            int_curve = multiple2SingleImprofile(obj.int{tpoint},defaultSpindleParameters());
            extraplot_profile({int_curve},iscurrent,1)
            
            x = 1:numel(int_curve);
            hold on
            
            plot(x,gaussian(x,obj.fit(tpoint,:)))
            edges = obj.getEdges(tpoint);
            scatter(edges,gaussian(edges,obj.fit(tpoint,:)))
            
        case 'IOS: Spindle length vs.total intensity'
            extraplot_many(obj.midz_int,iscurrent,tpoint,obj.spindle_feature.len,category)
        case 'IOS: Spindle length vs. ratio spindle/cell'
            extraplot_many(obj.midz_int./obj.midz_tub,iscurrent,tpoint,obj.spindle_feature.len,category)
            
        case 'IOS: intensity background'
            extraplot_many(obj.bg,iscurrent,tpoint,[],category)
        end
        end
        
        function [edges] = getEdges(self,i)
            width = 2;
            edges = [self.fit(i,2)-width*self.fit(i,3) self.fit(i,2)+width*self.fit(i,3)];
            edges = round(edges);
            len_i = size(self.spindle_feature.spind{i},1);
            if edges(1)<1||edges(1)>len_i
                edges(1)=1;
            end
            
            if edges(end)>len_i||edges(end)<1
                edges(2)=len_i;
            end
        end
        
        function displayCloseup(self,i,x_lims,y_lims,transposing)

            hold on
            [xx,yy]=self.spindle_feature.spindleParallelCurves(i);
            xx = xx-x_lims(1)+1;
            yy = yy-y_lims(1)+1;
            
            color = 'red';
            xx = xx([1,end],:);
            yy = yy([1,end],:);

            if ~transposing
                plot(xx',yy',color,'LineWidth',2)
            else
                plot(yy',xx',color,'LineWidth',2)
            end
            
            color = 'green';
            edges = self.getEdges(i);

            xx = xx(:,edges);
            yy = yy(:,edges);

            if ~transposing
                plot(xx,yy,color,'LineWidth',2)
            else
                plot(yy,xx,color,'LineWidth',2)
            end
            
        end
    end
end