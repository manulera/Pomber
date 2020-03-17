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

        % Mask of the intensity on the spindle
        masks
        
        % Edges of the signal on the spindle
        edges
        
        % Signal length 
        signal_length
        
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
            obj.edges = zeros(tpoints,2);
            obj.signal_length = zeros(1,tpoints);
            
            obj.masks = zeros(size(c.masks));
            
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
            for i = which_i
                cell_mask = cell_masks(:,:,i);
                prob = probs(:,:,i);
                mask = cell_mask & prob>0.6;
                self.masks(:,:,i)=mask;
            end
            
        end
        
        function draw(self,cut_video,x_bound,y_bound,which_i,contrast,cut_extra)
            figure
            
            for i = which_i
                ima = cut_video(:,:,i);
                self.masks(:,:,i) = draw_ios( ima,contrast,self.masks(:,:,i),x_bound,y_bound,0);
                cla
            end
            close
        end
        
        
        function postProcess(self,cut_video,cell_masks)
            for i = 1:size(self.masks,3)
                mask = self.masks(:,:,i);
                
                % Intersect the mask of the signal with the full-width
                % spindle
                [xx,yy]=self.spindle_feature.spindleParallelCurves(i);
                edges_i = false(1,size(xx,2));
                
                for j = 1:size(xx,1)
                    [edges_j,~] = intersectLineMask(xx(j,:),yy(j,:),mask);
                    edges_i = edges_i|edges_j;
                end
                
                % We only need the info of first and last true values (edges)
                edges_i = find(edges_i);
                if isempty(edges_i)
                    edges_i = [nan nan];
                end
                self.edges(i,:) = edges_i([1,end]);
                
                % Calculate the length of the spindle comprised between the
                % edges
                x = self.spindle_feature.spind{i}(:,1);
                y = self.spindle_feature.spind{i}(:,2);
                
                keep = edges_i(1):edges_i(end);
                if ~isnan(keep)
                    self.signal_length(i) = sum(sqrt(diff(x(keep)).^2+diff(y(keep)).^2));
                else
                    self.signal_length(i)=0;
                end
            end
        end
        
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
                
                keep = self.edges(i,1):self.edges(i,2);
                
                if ~isnan(keep)
                    self.midz_int(i) = sum(self.int_summed{i}(keep));
                    self.midz_tub(i) = sum(self.spindle_feature.int_summed{i}(keep));
                else
                    self.midz_int(i) = 0;
                    self.midz_tub(i) = 0;
                end
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
            
            edges_fit = obj.getEdges(tpoint);
            scatter(edges_fit,gaussian(edges_fit,obj.fit(tpoint,:)))
            
            edges_mask = obj.edges(tpoint,:);
            scatter(edges_mask,gaussian(edges_mask,obj.fit(tpoint,:)))
            
        case 'IOS: Spindle length vs.total intensity'
            extraplot_many(obj.midz_int,iscurrent,tpoint,obj.spindle_feature.len,category)
        case 'IOS: Spindle length vs. ratio spindle/cell'
            extraplot_many(obj.midz_int./obj.midz_tub,iscurrent,tpoint,obj.spindle_feature.len,category)
            
        case 'IOS: intensity background'
            extraplot_many(obj.signal_length,iscurrent,tpoint,obj.spindle_feature.len,category)
        end
        end
        
        function [edges] = getEdges(self,i)
%             x = self.spindle_feature.spind{i}(:,1);
%             y = self.spindle_feature.spind{i}(:,1);
%             intersectLineMask(x,y,mask)
            
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
            
            
            
            if ~any(isnan(self.edges(i,:)))
                xx = xx(:,self.edges(i,:));
                yy = yy(:,self.edges(i,:));

                if ~transposing
                    plot(xx,yy,color,'LineWidth',2)
                else
                    plot(yy,xx,color,'LineWidth',2)
                end
            end
            
        end
        
        function displayBigIma(self, which_i,rows,cols,sizes,x0,y0,transposing)
            
            for i =1:numel(which_i)
                [ro,co] = ind2sub([rows,cols],i);
                cor1 = sizes(2)*(co-1);
                cor2 = sizes(1)*(ro-1);
                t = which_i(i);
                
                cont = bwboundaries(self.masks(:,:,t));

                
                for j = 1:numel(cont)
                    x = cont{j}(:,2)-x0+1;
                    y = cont{j}(:,1)-y0+1;
                    if ~transposing
                        p=plot(x+cor1,y+cor2,'blue','LineWidth',1);
                    else
                        p=plot(y+cor1,x+cor2,'blue','LineWidth',1);
                    end
%                     p.Color(4)=0.3;
                end
            end
        end
    end
end