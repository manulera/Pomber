classdef f_dots < f_base
%F_DOTS Summary of this class goes here
%   Detailed explanation goes here

properties
    %% Main
    coords
    
    %% Derived
    dist
    dist_sep
    
end

methods
    %% Constructor and related
    function obj = f_dots(c)
        obj = obj.clear(c);
    end
    function obj = find(obj,c,channel,im_info,which_frames)
        c.an_type(channel) = 3; % The id of the analysis
        for i = which_frames(:)'
            ima = c.video{channel}(:,:,i);
            ima = ima.*c.masks(:,:,i);
            obj.coords{i} = find_dots(ima);
        end
    end
    function obj = clear(obj,c)
        obj.name = 'dots';
        tpoints = numel(c.list);
        obj.coords = cell(1,tpoints);
        obj.dist = zeros(1,tpoints);
        obj.dist_sep = nan(tpoints,2);
    end
    function obj = copy(obj,i_this,other,i_other)
        obj.coords{i_this} = other.coords{i_other};
    end
    %% Correction/update
    function obj = update(obj,c,channel,im_info)
        obj = postProcess(obj,c,channel,im_info);
    end
    function obj = correct_onstack(obj,c,channel,t,im_info,filename)
        contrast = im_info.contrast(channel,:);
        i = find(c.list==t);
        c.display_stack(filename,contrast)
        [y,x] = ginput(2);
        
        x = mod(x,c.size(1));
        close
        obj.coords{i} = [x(:) y(:)];
        obj.dist(i) = sqrt(sum(diff(obj.coords{i}).^2));
    end
    function obj = draw(obj,c,channel,im_info,which_frames)
        for i = which_frames(:)'
            ima = c.video{channel}(:,:,i);
            ima = ima.*c.masks(:,:,i);
            [x,y] = draw_dots( ima,im_info.contrast(channel,:));
            obj.coords{i} = [x(:) y(:)];
        end
    end
    
    %% Export
    function export(obj,dir_dots,time,im_info )
        res = im_info.resolution;
        % Is directory 
        if ~isdir(dir_dots)
            mkdir(dir_dots)
        end

        %intensity = [dir_dots filesep 'intensity.txt'];


        print_csv_cell(dir_dots,'coords',{obj.coords},[1 1 res res],'.txt')

        dir_pix = [dir_dots filesep 'in_pix'];
        if ~isdir(dir_pix)
            mkdir(dir_pix)
        end

        print_csv_array(dir_dots,'t_dist',[time(:) obj.dist(:)],[1 res],'.txt' )
    end
    
    %% Display
    function display_closeup(obj,i)
        hold on
        scatter(obj.coords{i}(1,2),obj.coords{i}(1,1),300,'green','LineWidth',1)
        scatter(obj.coords{i}(2,2),obj.coords{i}(2,1),300,'cyan','LineWidth',1)
    end
    function extraplot(obj,name,iscurrent,tpoint,category)
        switch name
        case 'Dots: distance'
            extraplot_many(obj.dist,iscurrent,tpoint,[],category)
        case 'Dots: distance both'
            if iscurrent
                
                hold on
                plot(obj.dist_sep(:,1),'green','LineWidth',2)
                plot(obj.dist_sep(:,2),'cyan','LineWidth',2)
                scatter(tpoint,obj.dist_sep(tpoint,1),'MarkerFaceColor','k','MarkerEdgeColor','green')
                scatter(tpoint,obj.dist_sep(tpoint,2),'MarkerFaceColor','k','MarkerEdgeColor','cyan')
            end
        end
    end
    function display_bigima(obj, which_frames,rows,cols,sizes )
        c = obj.coords;
        for i =1:numel(which_frames)
            [ro,co] = ind2sub([rows,cols],i);
            cor1 = sizes(2)*(co-1);
            cor2 = sizes(1)*(ro-1);
            t = which_frames(i);
            scatter(c{t}(:,2)+cor1,c{t}(:,1)+cor2,'red')
        end
    end
    
    %% Particular
    function obj = postProcess(obj,c,channel,im_info)
        % Assign identity to the dots
        obj = obj.assign_identity();
        % Calculate distance between the dots.
        for i = 1:numel(obj.coords)
            obj.dist(i) = sqrt(sum(diff(obj.coords{i}).^2));
        end
        for i = 1:numel(obj.coords)
            obj.dist_sep(i,:) = sqrt(sum((obj.coords{i}-obj.coords{end}).^2,2))';
        end
    end
    function obj = assign_identity(obj)
        all_coords = [obj.coords{:}];
        all_x = all_coords(:,1:2:end);
        all_y = all_coords(:,2:2:end);
        last_x = all_x(:,1);
        last_y = all_y(:,1);
        for i = 2:size(all_x,2)
            dist1 = sum((last_x-all_x(:,i)).^2+(last_y-all_y(:,i)).^2);
            dist2 = sum((last_x-all_x(end:-1:1,i)).^2+(last_y-all_y(end:-1:1,i)).^2);

            
            if dist2<dist1
                % Switch the coordinates, because they are different points
                obj.coords{i} = obj.coords{i}(end:-1:1,:);
            end
            last_x = obj.coords{i}(:,1);
            last_y = obj.coords{i}(:,2);
        end
    end
end
end

