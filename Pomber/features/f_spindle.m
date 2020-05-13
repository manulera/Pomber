classdef f_spindle < f_base
    
properties
    %% Main properties
    
    % cell array with coordinates of the spindle in different time
    % points.
    spind
    % Intensity along the spindle (tubulin signal)
    int
    % The threshold for the spindle masks
    spindle_mask_thresh
     
    
    
    %% Derived properties
    % Length of the spindle
    len
    % Distance between poles 
    dist
    % Ratio of intensity of spindle vs. intensity of cytoplasm
    r_spindle
    % Total intensity on the spindle for each time point
    tot_int
    % Backgound value for each image
    bg
    % Fit of function to the spindle
    length_fit
    % Spindle masks
    masks
    % The fit done to make the spindle line
    spindle_trace_fit
    % Indicates whether the spindle has been drawn or it comes from a fit
    drawn
    
    % Intensity profile (only the center)
    int_summed
    
    
end

methods
    %% Constructor and related
    
    function obj = f_spindle(c)
        obj.clear(c);
    end
    function clear(obj,c)
        obj.name = 'spindle';
        tpoints = numel(c.list);
        obj.spind = cell(1,tpoints);
        obj.int = cell(1,tpoints);
        obj.int_summed = cell(1,tpoints);
        obj.masks = zeros(size(c.masks));
        obj.len = zeros(1,tpoints);
        obj.dist = zeros(1,tpoints);
        obj.r_spindle = zeros(1,tpoints);
        obj.tot_int = zeros(1,tpoints);
        obj.bg = zeros(1,tpoints);
        obj.spindle_mask_thresh = 0.4;
        obj.spindle_trace_fit = zeros(tpoints,4);
        obj.drawn = false(tpoints,1);
    end
    function self = copy(self,i_this,other,i_other)
        self.spind{i_this} = other.spind{i_other};
        self.masks(:,:,i_this) = self.masks(:,:,i_other);
    end
    %% Finding and correcting
    function find(self,cut_video,cell_masks,im_info,which_i,spindle_probs)
        
        % Logical variable to indicate whether we do a second order polyn.
        % fit, or just linear fit.
        if which_i(1) ==1
            second_degree = false;
        elseif ~isnan(im_info.resolution)
            sp = self.spind{which_i(1)-1};
            if ~isempty(sp)
                second_degree = size(sp,1)*im_info.resolution > 6;
            end
        end
        
        for i = which_i
            ima = cut_video(:,:,i);
            cell_mask = cell_masks(:,:,i);
            spindle_prob = spindle_probs(:,:,i);
            [fit_par] = findSpindlePoly( ima ,cell_mask,second_degree,spindle_prob);
            [x,y,mask] = cutSpindlePoly(cell_mask.*spindle_prob,fit_par,0.6);
            self.spindle_trace_fit(i,:) = fit_par;
            self.spind{i}=[x(:) y(:)];
            self.masks(:,:,i)=mask;
            
            if ~isnan(im_info.resolution)
                second_degree = numel(x)*im_info.resolution > 6;
            end
        end
    end
    function draw(self,cut_video,x_bound,y_bound,which_i,contrast,cut_extra)
        figure
        for i = which_i
            ima = cut_video(:,:,i);
            self.spind{i} = draw_spindle( ima,contrast,self.spind{i},x_bound,y_bound,0);
            x = self.spind{i}(:,1);
            y = self.spind{i}(:,2);
            
            sugg_ang = atan((y(end)-y(1))/(x(end)-x(1)));
            
            if numel(x)==2
                self.spindle_trace_fit(i,:) = [sugg_ang,mean(x),mean(y),0];
                [x,y]=resamplePolylineXY(x,y);
            else
                [x,y]=resamplePolylineXY(x,y);
                self.spindle_trace_fit(i,:)=orthogonalFit(x,y,[sugg_ang,mean(x),mean(y),0],1,'robust');
            end
            
            self.drawn(i) = true;
            [~,self.masks(:,:,i)] = intersectLineMask(x,y,cut_extra(:,:,i)>0.4);
            cla
        end
        close
    end
    
    %% Functions called after the feature is found
    
    function postProcess(self,cut_video,cell_masks)
%         im_bg_all = im_info.im_bg(:,channel);

        for i = 1:numel(self.spind)

            s = self.spind{i};
            % In case you get a very small spindle, you could get its length 0
            
            if ~isempty(s) && ~any(isnan(s(:)))
%                 im_bg = im_bg_all(i);
                self.dist(i) = sqrt(sum((s(1,:)-s(end,:)).^2));
                self.len(i) = sum(sqrt(sum(diff(s).^2,2)));
                self.spind{i} = resamplePolyline(self.spind{i},ceil(self.len(i)));
%                 ima = c.video{channel}(:,:,i)-im_bg;
% 
%                 [ obj.int{i},obj.tot_int(i),obj.r_spindle(i),obj.bg(i) ] = ...
%                     intensity_on_spindle( ima,s,c.masks(:,:,i));
            else
                self.int{i} = 0;
            end
        end
        if true
            self.length_fit = OLSfit(1:(numel(self.len)),self.len, @spindle_trace_fun, [5,15,25,1,1,5,self.len(1)],'Robust');
        end
        
        
    end
    function measureIntensity(self,cut_video,cell_masks)
        for i = 1:numel(self.spind)
            % Background calculation and substraction
            ima = cut_video(:,:,i);
            mask = cell_masks(:,:,i);
            self.bg(i) = image_background(ima(mask));

            % Measure the intensity on a width of 3 pixels around the
            % spindle
            
            x = self.spind{i}(:,1);
            y = self.spind{i}(:,2);
            fit = self.spindle_trace_fit(i,:);
            
            [self.int{i},self.tot_int(i)] = spindleLinescan(x,y,fit,ima);
            self.int_summed{i} = multiple2SingleImprofile(self.int{i},defaultSpindleParameters());
            
            
        end
            
    end

    %% Export
    function export(self,dir_sp,time,im_info)
        res = im_info.resolution;
        % Spindle directory 
        if ~isdir(dir_sp)
            mkdir(dir_sp)
        end
        
        % Masks
        dir_mask = [dir_sp filesep 'mask'];
        if ~isdir(dir_mask)
            mkdir(dir_mask)
        end


        % Make the abscissa values and save the masks
        nb_tps = numel(time);
        absci_t = cell(1,nb_tps);
        for t = 1:nb_tps
            absci_t{t} = linspace(0,self.len(t),numel(self.int{t}))';
            % We do not use mask spindles anymore, but keep the code in case we
            % take them back
            %name = ['mask_t' num2str(t) '.tif'];
            %imwrite(logical(obj.mask(:,:,t)),[dir_mask filesep name])
        end
        print_csv_cell(dir_sp,'spindles',{self.spind},[1 1 res res],'.txt')
%         print_csv_cell(dir_sp,'contours',{obj.cont},[1 1 res res],'.txt')
%         print_csv_cell(dir_sp,'absci_int',{absci_t,obj.int },[1 1 res res],'.txt')
        print_csv_array( dir_sp,'t_len_dist',[time(:) self.len(:) self.dist(:)],[1 res res],'.txt' )
%         print_csv_array( dir_sp,'len_ratio_totint',[obj.len(:) obj.tot_int(:) obj.r_spindle(:)],[res 1 1],'.txt' )
    end
    
    %% Display
    
    function [xx,yy]=spindleParallelCurves(self,i)
        
        x = self.spind{i}(:,1);
        y = self.spind{i}(:,2);
        p = defaultSpindleParameters();
        [xx,yy]=makeParallelCurves(x,y,self.spindle_trace_fit(i,:),p.signal_width,1);
        
    end
    
    function displayCloseup(self,i,x_lims,y_lims,transposing)
        color = 'red';
        hold on
        [xx,yy]=self.spindleParallelCurves(i);
        xx = xx-x_lims(1)+1;
        yy = yy-y_lims(1)+1;
        
        xx = xx([1,ceil(end/2),end],:);
        yy = yy([1,ceil(end/2),end],:);
        
        if ~transposing
            plot(xx',yy',color,'LineWidth',1)
        else
            plot(yy',xx',color,'LineWidth',1)
        end
        
        display_mask = false;
        if display_mask
            spin_mask = self.masks(:,:,i);
            if any(spin_mask(:))
                cont = bwboundaries(spin_mask);

                for j = 1:numel(cont)
                    xx = cont{j}(:,2)-x_lims(1)+1;
                    yy = cont{j}(:,1)-y_lims(1)+1;
                    if ~transposing
                        p=plot(xx,yy,'blue','LineWidth',1);
                    else
                        p=plot(yy,xx,'blue','LineWidth',1);
                    end
%                     p.Color(4)=0.3;
                end
            end
        end

    end
    function extraplot(obj,name,iscurrent,tpoint,category)
        
        switch name
        % Spindle
        case 'Spindle: length'
            if ~isempty(obj.length_fit)
                
                tt = 1:numel(obj.len);
                extraplot_many(obj.len,iscurrent,tpoint,tt-obj.length_fit(2),category)
                if iscurrent
                    plot(tt-obj.length_fit(2),spindle_trace_fun(tt,obj.length_fit),'.-k')
                end
            else
                extraplot_many(obj.len,iscurrent,tpoint,[],category)
            end
            
        case 'Spindle: tubulin intensity profile'
            if isempty(tpoint)
                return
            end
            int_curve = multiple2SingleImprofile(obj.int{tpoint},defaultSpindleParameters());
            extraplot_profile({int_curve},iscurrent,1)
            
        case 'Spindle: length vs. total intensity'
            extraplot_many(obj.tot_int,iscurrent,tpoint,obj.len,category)
            
        case 'Spindle: length vs. ratio spindle/cell'
            if ~isempty(obj.length_fit)
                tt = 1:numel(obj.len);
                extraplot_many(obj.tot_int./obj.len,iscurrent,tpoint,tt-obj.length_fit(2),category)
            else
                extraplot_many(obj.tot_int./obj.len,iscurrent,tpoint,obj.len,category)
            end
            
        case 'Spindle: intensity background'
            extraplot_many(obj.bg,iscurrent,tpoint,[],category)
        end
    end
    function displayBigIma(obj, which_i,rows,cols,sizes,x0,y0,transposing)
        s = obj.spind;
%         c = obj.cont;
        for i =1:numel(which_i)
            [ro,co] = ind2sub([rows,cols],i);
            cor1 = sizes(2)*(co-1);
            cor2 = sizes(1)*(ro-1);
            t = which_i(i);
            x = s{t}(:,1)-x0+1;
            y = s{t}(:,2)-y0+1;
            if ~transposing
                plot(x+cor1,y+cor2,'cyan')
            else
                plot(y+cor1,x+cor2,'cyan')
            end
%             if ~isempty(c{t})
%                 h = plot(c{t}(:,2)+cor1,c{t}(:,1)+cor2,'yellow');
%             end
%             h.Color(1,4) = 0.3;
        end
    end
    

end
end

