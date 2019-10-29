function [ raw, nb_tpoints,channels,resolution,time ] = ReadImages2( direc,do_max )
    if nargin<2
        do_max = false;
    end
    raw = cell(1,3);
    cheat = {'dic pos1.tif','cen2gfp pos1.tif','mcatb2 pos1.tif'};
    for i = 1:3
        %[direc, pathname] = uigetfile('*.tif');
        r = bfopen([direc filesep cheat{i}]);
        omeMeta = r{1,4};
        r = r{1}(:,1);
        frame1 = r{1};
        nb_tpoints = numel(r);
        if i ==1
            time = nan(1,nb_tpoints);
            resx = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROM).floatValue;
            resy = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROM).floatValue;
            resolution = [resx resy];
        end
        raw{i} = zeros([size(frame1) nb_tpoints]);
        for j = 1:nb_tpoints
            raw{i}(:,:,j) = r{j};
            if i==1
                time(j) = omeMeta.getPlaneDeltaT(0,j-1).value(ome.units.UNITS.SECOND);
            end
        end
    end
    channels = cheat;
    
end

