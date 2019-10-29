function [ raw, nb_tpoints,channels,resolution,time ] = ReadImages( direc,do_max )
    if nargin<2
        do_max = false;
    end
    
    [ channels,files,nb_chan,nb_tpoints,nb_z,z_step ] = compiled_run( [direc filesep 'guide.m'] );
    % remove this
    % nb_tpoints = 40;
    % Extract the first image of each to see size of the images
    raw = cell(nb_chan,1);
    time = nan(1,nb_tpoints);
    for i =1:nb_chan
        barry = waitbar(0,['Channel ' num2str(i) ', Veuillez patienter...']);
        a = bfopen([direc filesep files{i}{1}]);
        % Prealocation of the memory where the images will be loaded
        raw{i} = zeros([size(a{1}{1}) nb_z(i) nb_tpoints]);
        
        for t = 1:nb_tpoints
            waitbar(t/nb_tpoints)
            out = bfopen([direc filesep files{i}{t}]);
            % Take the time only in the first channel
            if i==1
                time(t) = out{1,2}.get('Global timestamp #1');
                if t==1
                    omeMeta = out{1,4};
                    resx = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROM).floatValue;
                    resy = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROM).floatValue;
                    resolution = [resx resy];
                end
            end
            for z =1:size(out{1},1)
                raw{i}(:,:,z,t) = out{1}{z,1};
            end
        end
        if do_max
            raw{i} = squeeze(maximal_proj(raw{i},3));
        end
        close(barry)
    end
    
    time = (time - time(1))/1000;
end

