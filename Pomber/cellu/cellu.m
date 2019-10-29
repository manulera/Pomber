classdef cellu
    %CELLU The cell object
    
    properties
        % No idea what this is
        output
        first_time
        % Whether it is DIC or not
        dic
        % An object [x_size,y_size,t_size] with the masks of the cell
        masks
        % A list of the time frames in which the cell is present
        list
        % The size of the original video
        size
        % The angle that was used to rotate the image and generate the
        % small cropped
        angle
        % I think the limits to generate the cropped image 
        xlims
        ylims
        % The contrast to display the cell in the different channels
        contrast
        % The number of channels in the video
        channels
        % The images to plot I guess during CellProfile, this could be
        % deleted 
        ima_long
        % Size of the small video
        cropsize
        % Contour of the cell in the small video
        cont
        % I dont know
        omit
        % Something related to cropping as well
        keepx
        keepy
        % From cell profiler, the limit to show in CellProfile.
        % dispensable
        limshow
        % Whether it is the current cell.
        current
        % The small video
        video
        % The type of analysis for each channel
        an_type
        % You can assign several categories here
        mitmei
        % The edges of the box to crop the video
        ini_box
        % Some edges, to be understood at some point
        xmain
        ymain
        % features
        features
        
        sp
        dots
        ios
        
    end
    methods
        function obj = clear(obj,in)
            obj.output = in.output;
            obj.first_time = in.first_time;
            obj.dic = in.dic;
            obj.masks = in.masks;
            obj.list = in.list;
            obj.size = in.size;
            obj.angle = in.angle;
            obj.xlims = in.xlims;
            obj.ylims = in.ylims;       
            obj.contrast = in.contrast;
            obj.channels = in.channels;
            obj.ima_long = in.ima_long;
            obj.cropsize = in.cropsize;
            obj.cont = in.cont;
            obj.omit = in.omit;
            obj.keepx = in.keepx;
            obj.keepy = in.keepy;
            obj.limshow = in.limshow;
            obj.current = in.current;
            obj.video = in.video;
            obj.an_type = in.an_type;
            obj.mitmei = in.mitmei;
            obj.ini_box = in.ini_box;
            obj.xmain = in.xmain;
            obj.ymain = in.ymain;
        end
        function obj = set_features(obj,other)
            for i = 1:numel(other.features)
                switch other.features{i}.name
                    case 'spindle'
                        obj.features{i} = f_spindle(obj);
                    case 'dots'
                        obj.features{i} = f_dots(obj);
                end
            end
            
        end
        function obj = cellu(in)
            obj = obj.clear(in);
            obj.features = cell(1,obj.channels);
            for i = 1:obj.channels
                obj.features{i} = f_base();
            end
        end
        function obj = correct(obj,time,im_info)
            i = find(obj.list==time);
            for c =1:obj.channels
                obj.features{c} = obj.features{c}.draw(obj,c,im_info,i);
                obj.features{c} = obj.features{c}.post_process(obj,c,im_info);
            end
        end
        function obj = correct_onstack(obj,time,im_info,stacks)
            for i =1:obj.channels
                filename = [stacks{i}.folder filesep stacks{i}.name];
                obj.features{i} = obj.features{i}.correct_onstack(obj,i,time,im_info,filename);
            end
        end
        function obj = update(obj,other,im_info)
            obj = obj.set_features(other);
            % See which ones intersect
            merge = intersect(obj.list,other.list);
            for t =merge
                i_other = find(other.list==t);
                i_this = find(obj.list==t);
                for c =1:obj.channels
                    obj.features{c} = obj.features{c}.copy(i_this, other.features{c}, i_other);
                end
            end
            [~,missing] = setdiff(obj.list,merge);
            
            for c =1:obj.channels
                if ~isempty(obj.features{c}.name)
                    obj = obj.find_feature(c,im_info,0,missing);
                end
            end
            
            
        end
        %% Display
        function display_closeup(obj,i,channel)
            hold on
            plot(obj.cont{i}(:,2),obj.cont{i}(:,1),'yellow')
            obj.features{channel}.display_closeup(i);
        end
        function display_square(obj,color)
            plot(obj.ini_box(:,1),obj.ini_box(:,2),color,'LineWidth',2)
        end
        function extraplot(obj,name,iscurrent,tpoint)
            for i = 1:obj.channels
                obj.features{i}.extraplot(name,iscurrent,tpoint,obj.mitmei+1);
            end
        end
        function display_stack(obj,filename,contrast)
            reader = Tiff(filename);
            big_ima = [];
            nb_z = imfinfo(filename);
            for z =1:numel(nb_z)
                trim = 1;
                reader.setDirectory(z);
                ima = reader.read();
                ima = ima(:,trim:end);
                ima = ima(obj.xmain,obj.ymain);
                ima = rotate_ima(ima,obj.angle,[],obj.xlims,obj.ylims );
                sizes = size(ima);
                big_ima = [ima;big_ima];
            end
            figure
%             imshow(big_ima,contrast,'InitialMagnification','fit')
            imagesc(big_ima,contrast)
            axis equal
            hold on
            for i =1:numel(nb_z)
                plot(obj.cont{i}(:,2),obj.cont{i}(:,1)+sizes(1)*(i-1),'white')
            end
        end
        %% Export
        function export(obj,handles,dir_c)
            if ~isdir(dir_c)
                mkdir(dir_c)
            end
            %% Save the small video
            dir_video = [dir_c filesep 'video'];
            if ~isdir(dir_video)
                mkdir(dir_video)
            end
            for j = 1:numel(obj.video)
                if j~=4
                    format = '.tif';
                else
                    format = '.png';
                end
                for t = 1:numel(obj.list)
                    name = ['frame_c' num2str(j) '_t' num2str(t) format];
                    if j~=4
                        imwrite(uint16(obj.video{j}(:,:,t)),[dir_video filesep name])
                    else
                        imwrite(squeeze(obj.video{j}(:,:,t,:)),[dir_video filesep name])
                    end
                end
            end
            %% Save the masks
            for t = 1:numel(obj.list)
                name = ['mask_t' num2str(t) '.tif'];
                imwrite(logical(obj.masks(:,:,t)),[dir_video filesep name])
            end
            %% Save data of the cell

            % A text file containing the indexes of the timepoints spanned in
            % the video.
            dlmwrite([dir_c filesep 'time_indexes.txt'],obj.list(:))
            real_t = handles.time(obj.list(:));
            real_t = real_t-real_t(1);
            dlmwrite([dir_c filesep 'time_values.txt'],real_t(:))

            % A text file containing the information to crop the video
            % First two columns x,y limits of the main square before cell
            % profiling.
            % Third column the angle at which you have to rotate that square
            % Following two columns x,y limits once the image is rotated to
            % generate the small images stored.
            xy_crop = [obj.xmain(1) obj.xmain(end);obj.ymain(1) obj.ymain(end); obj.angle 0;obj.xlims(1) obj.xlims(end);obj.ylims(1) obj.ylims(end)]';
            dlmwrite([dir_c filesep 'xy_crop.txt'],xy_crop)

            % The contour of the cell in coordinates
            contours = [dir_c filesep 'cell_contours.txt'];
            contours_um = [dir_c filesep 'cell_contours_um.txt'];

            % A file that currently only contains the info of whether it is
            % mitosis, meiosis or whatever, but potentially could contain more info
            pom_export_categories(obj,dir_c,handles)

            for name = {contours,contours_um}
                if exist(name{1},'file')
                    delete(name{1})
                end
            end

            res=handles.im_info.resolution;
            print_csv_cell(dir_c,'cell_contours',{obj.cont},[1 1 res res],'.txt')
            for i =1:obj.channels
                name = obj.features{i}.name;
                obj.features{i}.export([dir_c filesep name],real_t,handles.im_info);
            end
        end
        %% Update/repeat
        function obj = update_analysis(obj,im_info)
            for i = 1:obj.channels
                obj.features{i} = obj.features{i}.update(obj,i,im_info);
            end
        end
        function obj = repeat(obj,im_info)
            for i = 1:obj.channels
                obj = obj.find_feature(i,im_info,1);
            end
        end
        %% Misc
        function value = find_channel(obj,feature_name)
            value = [];
            for i = 1:numel(obj.features)
                if strcmp(obj.features{i},feature_name)
                    value = 1;return
                end
            end
        end
        
        function [big_ima,sizes] = make_big_ima(obj,channel,which_frames,rows,cols)
            
            sizes = size(obj.video{channel});
            big_ima = zeros(rows*sizes(1),cols*sizes(2));
            
            % We loop to build the big image
            for i = 1:numel(which_frames)
                t = which_frames(i);
                ima = obj.video{channel}(:,:,t);
                ima = ima.*obj.masks(:,:,t);
                
                [ro,co] = ind2sub([rows,cols],i);
                xx = ((ro-1)*sizes(1)+1):(ro*sizes(1));
                yy = ((co-1)*sizes(2)+1):(co*sizes(2));
                big_ima(xx,yy) = ima;
            end
            
        end
        function obj = find_feature(obj,channel,im_info,repeat,which_frames)
            
            if nargin<4||isempty(repeat)
                repeat = 0;
            end
            if nargin<5
                which_frames = 1:numel(obj.list);
            end
            
            if ~isempty(which_frames)
                % Find the feature
                if ~repeat
                    obj.features{channel} = obj.features{channel}.find(obj,channel,im_info,which_frames);
                end

                % Display
                rows = 7;
                cols = ceil(numel(which_frames)/rows);
                [big_ima,sizes] = obj.make_big_ima(channel,which_frames,rows,cols);

                %set(gcf, 'Position', get(0, 'Screensize'));
                select = true;
                while select

                    figure('units','normalized','outerposition',[0 0 1 1])
                    imshow(big_ima,[],'InitialMagnification','fit')
                    title('Select the wrong spindles and click enter')
                    hold on

                    obj.features{channel}.display_bigima(which_frames,rows,cols,sizes)
                    [co,ro] = getpts();
                    close
                    select = ~isempty(co);
                    if select
                        alli = select_from_big_ima(ro,co,rows,cols,sizes);
                        obj.features{channel} = obj.features{channel}.draw(obj,channel,im_info,which_frames(alli));
                    end
                end
            end
            obj.features{channel} = obj.features{channel}.post_process(obj,channel,im_info);
        end
            
        
    end
end

