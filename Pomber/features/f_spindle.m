classdef f_spindle < f_base
    
properties
    %% Main properties
    % cell array with coordinates of the spindle in different time
    % points.
    spind
    % Contour of the maks of the spindle 
    cont
    % Intensity along the spindle (tubulin signal)
    int
    
    
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
    spindle_fit

end

methods
    %% Constructor and related
    
    function obj = f_spindle(c)
        obj = obj.clear(c);
    end
    function obj = clear(obj,c)
        obj.name = 'spindle';
        tpoints = numel(c.list);
        
        obj.spind = cell(1,tpoints);
        obj.cont = cell(1,tpoints);
        obj.int = cell(1,tpoints);
        
        obj.len = zeros(1,tpoints);
        obj.dist = zeros(1,tpoints);
        obj.r_spindle = zeros(1,tpoints);
        obj.tot_int = zeros(1,tpoints);
        obj.bg = zeros(1,tpoints);
    end
    function obj = find(obj,c,channel,im_info,which_frames)
        c.an_type(channel) = 3; % The id of the analysis
        prev_length = 0;
        for i = which_frames(:)'
            ima = c.video{channel}(:,:,i);
            ima = ima.*c.masks(:,:,i);
            [x,y,con] = find_spindle( ima ,prev_length,im_info.resolution);
            obj.cont{i} = con;
            obj.spind{i}=[x(:) y(:)];
            if ~isnan(im_info.resolution)
                prev_length = (max(y)-min(y))*im_info.resolution;
            end
        end
        
    end
    function obj = draw(obj,c,channel,im_info,which_frames)
        figure
        for i = which_frames(:)'
            ima = c.video{channel}(:,:,i);
            ima = ima.*c.masks(:,:,i);
            obj.spind{i} = draw_spindle( ima,im_info.contrast(channel,:),obj.spind{i},0);
            cla
        end
        close
    end
    function obj = post_process(obj,c,channel,im_info)
        im_bg_all = im_info.im_bg(:,channel);

        for i = 1:numel(c.list)

            s = obj.spind{i};
            % In case you get a very small spindle, you could get its length 0
            
            if ~isempty(s) && ~any(isnan(s(:)))
                im_bg = im_bg_all(i);
                obj.dist(i) = sqrt(sum((s(1,:)-s(end,:)).^2));
                obj.len(i) = sum(sqrt(sum(diff(s).^2,2)));
                obj.spind{i} = resamplePolyline(obj.spind{i},ceil(obj.len(i)));
                ima = c.video{channel}(:,:,i)-im_bg;

                [ obj.int{i},obj.tot_int(i),obj.r_spindle(i),obj.bg(i) ] = ...
                    intensity_on_spindle( ima,s,c.masks(:,:,i));
            else
                obj.int{i} = 0;
            end
        end
        if true
            obj.spindle_fit = OLSfit(1:(numel(c.list)),obj.len, @spindle_trace_fun, [5,15,25,1,1,2,10],'Robust');
        end
    end
    function obj = copy(obj,i_this,other,i_other)
        obj.spind{i_this} = other.spind{i_other};
        obj.cont{i_this} = other.cont{i_other};
    end
    %% Correct/update
    function obj = update(obj,c,channel,im_info)
        obj = obj.post_process(c,channel,im_info);
    end
    %% Export
    function export(obj,dir_sp,time,im_info)
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
            absci_t{t} = linspace(0,obj.len(t),numel(obj.int{t}))';
            % We do not use mask spindles anymore, but keep the code in case we
            % take them back
            %name = ['mask_t' num2str(t) '.tif'];
            %imwrite(logical(obj.mask(:,:,t)),[dir_mask filesep name])
        end
        print_csv_cell(dir_sp,'spindles',{obj.spind},[1 1 res res],'.txt')
        print_csv_cell(dir_sp,'contours',{obj.cont},[1 1 res res],'.txt')
        print_csv_cell(dir_sp,'absci_int',{absci_t,obj.int },[1 1 res res],'.txt')
        print_csv_array( dir_sp,'t_len_dist',[time(:) obj.len(:) obj.dist(:)],[1 res res],'.txt' )
        print_csv_array( dir_sp,'len_ratio_totint',[obj.len(:) obj.tot_int(:) obj.r_spindle(:)],[res 1 1],'.txt' )
    end
    %% Display
    function display_closeup(obj,i)
        color = 'red';
    
        if nargin<3
            edges = [];
        end
        hold on
        plot(obj.spind{i}(:,2),obj.spind{i}(:,1),color,'LineWidth',1)
        if ~isempty(edges)
            for j = 1:2
                if ~isnan(edges(j))
                    scatter(obj.spind{i}(edges(j),2),obj.spind{i}(edges(j),1),'yellow')
                    scatter(obj.spind{i}(edges(j),2),obj.spind{i}(edges(j),1),'yellow')
                end
            end
        end
    end
    function extraplot(obj,name,iscurrent,tpoint,category)
        switch name
        % Spindle
        case 'Spindle: length'
            extraplot_many(obj.len,iscurrent,tpoint,[],category)
            if iscurrent && ~isempty(obj.spindle_fit)
                tt = 1:numel(obj.len);
                plot(tt,spindle_trace_fun(tt,obj.spindle_fit),'.-k')
            end
        case 'Spindle: tubulin intensity profile'
            extraplot_profile(obj.int,iscurrent,tpoint)
        case 'Spindle: length vs. total intensity'
            extraplot_many(obj.tot_int,iscurrent,tpoint,obj.len,category)
        case 'Spindle: length vs. ratio spindle/cell'
            extraplot_many(obj.r_spindle,iscurrent,tpoint,obj.len,category)
        case 'Spindle: intensity background'
            extraplot_many(obj.bg,iscurrent,tpoint,[],category)    
        end
    end
    function display_bigima(obj, which_frames,rows,cols,sizes )
        s = obj.spind;
        c = obj.cont;
        for i =1:numel(which_frames)
            [ro,co] = ind2sub([rows,cols],i);
            cor1 = sizes(2)*(co-1);
            cor2 = sizes(1)*(ro-1);
            t = which_frames(i);
            plot(s{t}(:,2)+cor1,s{t}(:,1)+cor2,'cyan')
            if ~isempty(c{t})
                h = plot(c{t}(:,2)+cor1,c{t}(:,1)+cor2,'yellow');
            end
            h.Color(1,4) = 0.3;
        end
    end
    

end
end

