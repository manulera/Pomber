function [ raw, nb_tpoints,channels,resolution,time_out,position_name,position,stage_names ] = ReadImages3( direc,ndfile,do_max,position_name )
    if nargin<3
        do_max = false;
    end
    if nargin<4
        position_name = '';
    end
    
    [stage_names,nb_z,channels,skipped_wavelength] = ReadndFile(direc,ndfile);
    take_time = 1;
    if ~isempty(skipped_wavelength)
        take_time = 0;
        for i =1:numel(channels)
            if ~ismember(i,skipped_wavelength)
                take_time=i;
                break
            end
        end
        % If somehow all the wavelengths were not acquired every time
        if take_time ==0
            errordlg('There seems to be a problem with the number of wavelengths acquired per frame')
        end
    end
    [filenames, fileinfo] = MetamorphRegex(direc,ndfile);
    
    % If the position is provided
    if ~isempty(position_name)
        which_one = find(strcmp(position_name,stage_names));
        if numel(which_one)==1
            position = which_one;
        else
            position_name = '';
        end
    end
    % Select which position you want to do the analysis of
    if isempty(stage_names)
        position = 1;
    else
        if isempty(position_name)
            position = listdlg('ListString',stage_names,'SelectionMode',...
                'single','PromptString',{'Select the position ', 'you want to open'});
        end
        position_name= stage_names{position};
        keep = fileinfo(:,2)==position;
        fileinfo = fileinfo(keep,[1,3]);
        filenames = filenames(keep);
    end
    
    
    mm = max(fileinfo);
    nb_chan = mm(1);
    nb_tpoints = mm(2);
    % Extract the first image of each to see size of the images
    raw = cell(nb_chan,1);
    time = cell(1,nb_tpoints);
    resolution = nan;
    
    
    
    for i =1:nb_chan
        barry = waitbar(0,['Channel ' num2str(i) ', Veuillez patienter...']);
        log1 = fileinfo(:,1)==i;
        
        a = Tiff([direc filesep filenames{1}]);
        % Prealocation of the memory where the images will be loaded
        raw{i} = zeros([a.getTag('ImageLength') a.getTag('ImageWidth') nb_z(i) nb_tpoints]);
        
        for t = 1:nb_tpoints
            waitbar(t/nb_tpoints)
            log2 = fileinfo(:,2)==t;
            if ~sum(log1 & log2)
                % If the frame is empty, fill with previous
                raw{i}(:,:,:,t) = raw{i}(:,:,:,t-1);
                continue
            end
            reader = Tiff([direc filesep filenames{log1 & log2}]);
            for z =1:nb_z(i)
                reader.setDirectory(z);
                raw{i}(:,:,z,t) = reader.read();
            end
            % Take the time only in the first channel that has all time
            % points in it.
            if i==take_time
                time{t} = get_time_frommeta(reader.getTag('ImageDescription'));
            end
        end
        if do_max
            raw{i} = max(raw{i},[],3);
        end
        close(barry)
    end
    
    time_out = zeros(1,nb_tpoints);
    for i = 2:numel(time)
        time_out(i) = seconds(time{i} - time{i-1});
    end
    time_out = cumsum(time_out);
end

