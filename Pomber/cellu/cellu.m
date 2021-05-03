classdef cellu < handle
    %CELLU The cell object
    
    properties
        
        % An object [x_size,y_size,t_size] with the masks of the cell
        masks
        
        % A list of the time frames in which the cell is present
        list
        
        % You can assign several categories here
        mitmei
        
        % features
        features
        
        % For each channel, which kind of analysis has been done (default
        % is 1, which corresponds to none)
        an_type
        
    end
    methods
        %% Constructor and related
        function self = cellu(masks,list,an_type)
            % Create an empty cell, which only includes the masks of the
            % cell, where the cell is, and an empty array of analysis
            % types.
            self.masks = masks;
            self.list = list;
            self.an_type = an_type;
            nb_chans = numel(an_type);
            self.features = cell(1,nb_chans);
            self.mitmei = 0;
            [~,iter] = sort(an_type);
            for i = iter                
                switch an_type(i)
                    case 3
                        self.features{i} = f_spindle(self);
                    case 4
                        self.features{i} = f_ios(self);
                    case 5
                        self.features{i} = f_dots(self);
                    case 7
                        self.features{i} = f_ios_base(self);
                end
            end
        end
        
        %% Intersection
        
        function update(self,other,video,im_info,extra,sum_video)
            % Make an intersection of an empty cell (self) with a
            % pre-existing cell (other)
            
            % Copy the features of shared frames
            merge = intersect(self.list,other.list);
            for t =merge
                i_other = find(other.list==t);
                i_this = find(self.list==t);
                for c =1:numel(self.features)
                    if ~isempty(self.features{c})
                        self.features{c} = self.features{c}.copy(i_this, other.features{c}, i_other);
                    end
                end
            end
            [~,which_frames] = setdiff(self.list,merge);
            
            which_i = which_frames;
            for i = 1:numel(which_frames)
                which_i(i) = find(which_frames(i)==self.list);
            end
            % Get the features of missing frames
            self.findAllFeatures(video,im_info,extra,sum_video,0,which_i);
            
        end
        
        %% Finding 
        function findAllFeatures(self,video,im_info,extra,sum_video,repeat,which_i)
            
            if nargin<6||isempty(repeat)
                repeat = 0;
            end
            if nargin<7
                which_i = 1:numel(self.list);
            end
            
            [~,iter] = sort(self.an_type);
            % It is important to iterate in order, since for example
            % ios
            for i = iter
                if self.an_type(i)<3 || isempty(self.features{i})
                    continue;
                end
                % Check the empty frames here, otherwise it would not
                % update the cell when you have only removed frames in
                % cellu.update()
                cut_video = video{i}(:,:,self.list);
                if ~isempty(extra{i})
                    cut_extra = extra{i}(:,:,self.list);
                else
                    cut_extra = [];
                end
                cut_sum =sum_video{i}(:,:,self.list);
                if ~isempty(which_i)
                    if ~repeat||self.an_type(i)==4
                        self.features{i}.find(cut_video,self.masks,im_info,which_i,cut_extra)
                    end
                    self.displayFeature(cut_video,which_i,i,im_info,cut_extra,7);
                end
                self.features{i}.postProcess(cut_video,self.masks);
                self.features{i}.measureIntensity(cut_sum,self.masks);
            end 
            
        end
        %% Displaying
    
        function displayFeature(self,cut_video,which_i,channel,im_info,cut_extra,rows)
                if nargin<7||isempty(rows)
                    rows=7;
                end
                
                cols = ceil(numel(which_i)/rows);
                
                [small_video,x_bound,y_bound,transposing] = makeSmallVideo(cut_video(:,:,which_i),self.masks(:,:,which_i),0.6);
                small_masks = makeSmallVideo(self.masks(:,:,which_i),self.masks(:,:,which_i),0.6);                
                [big_ima,sizes] = makeBigIma(small_video.*small_masks,rows,cols);
                
                %set(gcf, 'Position', get(0, 'Screensize'));
                select = true;
                while select

                    figure('units','normalized','outerposition',[0 0 1 1])
                    imshow(big_ima,[],'InitialMagnification','fit')
                    title('Select the wrong features and click enter')
                    hold on

                    self.features{channel}.displayBigIma(which_i,rows,cols,sizes,x_bound(1),y_bound(1),transposing)
                    [co,ro] = getpts();
                    close
                    select = ~isempty(co);
                    if select
                        
                        alli = selectFromBigIma(ro,co,rows,cols,sizes);
                        self.features{channel}.draw(cut_video.*self.masks,x_bound,y_bound,which_i(alli),im_info.contrast(channel,:),cut_extra);
                    end
                end
        end
        function displaySquare(self,this_axis,color,t)
            i = find(t==self.list);
            cont = self.getContour(i);
            plot(this_axis,cont(:,2),cont(:,1),color,'LineWidth',2)
        end
        
        function small_video = makeSmallVideo(self,video)
            nb_channels = numel(video);
            small_video = struct();
            small_video.video = cell([1,nb_channels]);
            
            for i = 1:nb_channels
                this_channel = video{i}(:,:,self.list);
                [small_video.video{i},small_video.x_lims,small_video.y_lims,small_video.transposing] = makeSmallVideo(this_channel,any(self.masks,3),0.6);
            end
            small_video.contours = cell([1,numel(self.list)]);
            for i = 1:numel(self.list)
                small_video.contours{i} = self.getContour(i);
            end
            
        end
        
        function displayCloseUp(self,this_axis,small_video,t,channel,contrast)
            
            i = find(t==self.list);
            
            % Load from the small video previously generated
            ima = squeeze(small_video.video{channel}(:,:,i,:));
            x_lims = small_video.x_lims;
            y_lims = small_video.y_lims;
            cont  = small_video.contours{i};
            transposing = small_video.transposing;
            
            % Show the image
            imshow(ima,contrast,'InitialMagnification','fit','Parent',this_axis)
            
            % Plot the cell contour
            hold(this_axis,'on');
            xx = cont(:,2)-x_lims(1)+1;
            yy = cont(:,1)-y_lims(1)+1;
            if ~transposing
                plot(this_axis,xx,yy,'LineWidth',2)
            else
                plot(this_axis,yy,xx,'LineWidth',2)
            end
            
            % Plot the features
            if channel~=4
                if ~isempty(self.features{channel})
                    self.features{channel}.displayCloseup(this_axis,i,x_lims,y_lims,transposing)
                end
            end
            
        end
        
        
        %% Accesory useful functions
        function cont = getContour(self,i)
            cont = bwboundaries(self.masks(:,:,i));
            cont = cont{1};
        end
        
        function which_i = which_frames2which_i(self,which_frames)
            which_i = nan(1,numel(which_frames));
            for i = 1:numel(which_frames)
                which_i(i) = find(which_frames(i)==self.list);
            end
        end
        %% Plotting the data
        function extraplot(self,this_axis,name,iscurrent,t)
            i = find(t==self.list);
            for c = 1:numel(self.features)
                if ~isempty(self.features{c})
                    self.features{c}.extraplot(this_axis,name,iscurrent,i,self.mitmei+1);
                end
            end
        end
        
        %% Functions called after the feature is found
        
        function correct(self,video,t,im_info,extra,sum_video)
            i = find(self.list==t);
            
            % We iterate in increasing order, because the interdependent
            % features are in order. Example: a change in f_spindle, should
            % affect f_ios, but not viceversa.
            
            channel_nums = 1:numel(self.an_type);
            [~,sort_ind] = sort(self.an_type(self.an_type>=3));
            channel_nums=channel_nums(self.an_type>=3);

            for c = channel_nums(sort_ind)
                if isempty(self.features{c})
                    continue
                end
                cut_video = video{c}(:,:,self.list);
                if ~isempty(extra{c})
                    cut_extra = extra{c}(:,:,self.list);
                else
                    cut_extra = [];
                end
                cut_sum = sum_video{c}(:,:,self.list);
                [~,x_bound,y_bound] = makeSmallVideo(cut_video,self.masks,0.6);
                self.features{c}.draw(cut_video.*self.masks,x_bound,y_bound,i,im_info.contrast(c,:),cut_extra);
                self.features{c}.postProcess(cut_video,self.masks,i);
                self.features{c}.measureIntensity(cut_sum,self.masks,i);
            end
        end
        
        function update_analysis(self,video,sum_video)
            for c = find(self.an_type>=3)
                if ~isempty(self.features{c})
                    self.features{c}.postProcess(video{c}(:,:,self.list),self.masks);
                    self.features{c}.measureIntensity(sum_video{c}(:,:,self.list),self.masks)
                end
            end
        end
        
        function measureIntensity(self,sum_video)
            for c = find(self.an_type>=3)
                if ~isempty(self.features{c})
                    self.features{c}.measureIntensity(sum_video{c}(:,:,self.list),self.masks);
                end
            end
        end
        %% Export data
        function export(self,handles,dir_c)
            if ~isdir(dir_c)
                mkdir(dir_c)
            end
            
            writeTiffStack(logical(self.masks),[dir_c filesep 'mask.tiff'])

            % Save data of the cell ---------------------

            % A text file containing the indexes of the timepoints spanned in
            % the video.
            dlmwrite([dir_c filesep 'time_indexes.txt'],self.list(:))
            real_t = handles.time(self.list(:));
            real_t = real_t-real_t(1);
            dlmwrite([dir_c filesep 'time_values.txt'],real_t(:))

            % A file that currently only contains the info of whether it is
            % mitosis, meiosis or whatever, but potentially could contain more info
            pom_export_categories(self,dir_c,handles)
            
            for i =1:numel(self.features)
                if ~isempty(self.features{i})
                    name = self.features{i}.name;
                    self.features{i}.export([dir_c filesep name],real_t,handles.im_info);
                end
            end
        end
        
        
        
    end
end


