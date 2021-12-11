classdef f_ios < f_ios_base
    %FEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

        % Mask of the intensity on the spindle
        masks
        
        % Edges of the signal on the spindle
        edges
        
        % Signal length 
        signal_length
        
        % Midzone intensity (inside the mask)
        midz_int
        
        % Midzone tubulin intensity (inside the mask on the tubulin channel)
        midz_tub
    end
    
    methods
        %% Constructor and related
        function obj = f_ios(c)
            % If you don't specifically call the parent constructor here,
            % it will call it on its own without the argument (or something
            % like that)
            
            obj@f_ios_base(c);
            obj.name = 'ios';
            obj.clear(c);
        end
        function clear(obj,c)
            obj.clear@f_ios_base(c);
            tpoints = numel(c.list);
            obj.midz_int = zeros(1,tpoints);
            obj.midz_tub = zeros(1,tpoints);
            obj.signal_length = zeros(1,tpoints);
            obj.masks = zeros(size(c.masks));
            obj.edges = zeros(tpoints,2);
            obj.signal_length = zeros(1,tpoints);
            
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
        
        
        function postProcess(self,cut_video,cell_masks,indexes2analyze)
            if nargin<4||isempty(indexes2analyze)
                indexes2analyze = 1:size(self.masks,3);
            end
                
            for i = indexes2analyze
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
        function measureIntensity(self,cut_video,cell_masks,indexes2analyze)

            % Calculate the sum of intensity in the midzone
            if nargin<4
                indexes2analyze = 1:numel(self.spindle_feature.spind);
            end
            
            % Parent method
            self.measureIntensity@f_ios_base(cut_video,cell_masks,indexes2analyze);
            
            for i = indexes2analyze
                
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
        function extraplot(obj,this_axis,name,iscurrent,tpoint,category)
        
            % Parent method
            obj.extraplot@f_ios_base(this_axis,name,iscurrent,tpoint,category)
            
            switch name
            case 'IOS: intensity profile'
                if ~iscurrent
                    return
                end

                edges_fit = obj.getEdges(tpoint);
                scatter(this_axis,edges_fit,gaussian(edges_fit,obj.fit(tpoint,:)))

                edges_mask = obj.edges(tpoint,:);
                scatter(this_axis,edges_mask,gaussian(edges_mask,obj.fit(tpoint,:)))

            case 'IOS: Spindle length vs. midzone intensity'
                extraplot_many(this_axis,obj.midz_int,iscurrent,tpoint,obj.spindle_feature.len,category)
            case 'IOS: Spindle length vs. ratio spindle/cell'
                extraplot_many(this_axis,obj.midz_int./obj.midz_tub,iscurrent,tpoint,obj.spindle_feature.len,category)
            case 'IOS: intensity background'
                extraplot_many(this_axis,obj.signal_length,iscurrent,tpoint,[],category)
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
        
        function displayCloseup(self,this_axis,i,x_lims,y_lims,transposing)

            self.displayCloseup@f_ios_base(this_axis,i,x_lims,y_lims,transposing);
            
            color = 'green';
            
            [xx,yy]=self.spindle_feature.spindleParallelCurves(i);
            xx = xx-x_lims(1)+1;
            yy = yy-y_lims(1)+1;

            xx = xx([1,ceil(end/2),end],:);
            yy = yy([1,ceil(end/2),end],:);
            
            if ~any(isnan(self.edges(i,:)))
                xx = xx(:,self.edges(i,:));
                yy = yy(:,self.edges(i,:));

                if ~transposing
                    plot(this_axis,xx,yy,color,'LineWidth',2)
                else
                    plot(this_axis,yy,xx,color,'LineWidth',2)
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