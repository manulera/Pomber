function [  ] = pom_export_cell( c,dir_c,handles )
    
    if ~isdir(dir_c)
        mkdir(dir_c)
    end

    %% Save the small video
    dir_video = [dir_c filesep 'video'];
    if ~isdir(dir_video)
        mkdir(dir_video)
    end
    for j = 1:numel(c.video)
        if j~=4
            format = '.tif';
        else
            format = '.png';
        end
        for t = 1:numel(c.list)
            name = ['frame_c' num2str(j) '_t' num2str(t) format];
            if j~=4
                imwrite(uint16(c.video{j}(:,:,t)),[dir_video filesep name])
            else
                imwrite(squeeze(c.video{j}(:,:,t,:)),[dir_video filesep name])
            end
        end
    end
    %% Save the masks
    for t = 1:numel(c.list)
        name = ['mask_t' num2str(t) '.tif'];
        imwrite(logical(c.masks(:,:,t)),[dir_video filesep name])
    end
    %% Save data of the cell

    % A text file containing the indexes of the timepoints spanned in
    % the video.
    dlmwrite([dir_c filesep 'time_indexes.txt'],c.list(:))
    real_t = handles.time(c.list(:));
    real_t = real_t-real_t(1);
    dlmwrite([dir_c filesep 'time_values.txt'],real_t(:))
    
    % A text file containing the information to crop the video
    % First two columns x,y limits of the main square before cell
    % profiling.
    % Third column the angle at which you have to rotate that square
    % Following two columns x,y limits once the image is rotated to
    % generate the small images stored.
    xy_crop = [c.xmain(1) c.xmain(end);c.ymain(1) c.ymain(end); c.angle 0;c.xlims(1) c.xlims(end);c.ylims(1) c.ylims(end)]';
    dlmwrite([dir_c filesep 'xy_crop.txt'],xy_crop)
    
    % The contour of the cell in coordinates
    contours = [dir_c filesep 'cell_contours.txt'];
    contours_um = [dir_c filesep 'cell_contours_um.txt'];
    
    % A file that currently only contains the info of whether it is
    % mitosis, meiosis or whatever, but potentially could contain more info
    pom_export_categories(c,dir_c)
    
    for name = {contours,contours_um}
        if exist(name{1},'file')
            delete(name{1})
        end
    end

    res=handles.im_info.resolution;
    print_csv_cell(dir_c,'cell_contours',{c.cont},[1 1 res res],'.txt')
    for typ = c.an_type
        switch typ
            case 3 % Spindle
                pom_export_sp(c,[dir_c filesep 'spindle'],real_t,res);
            case 4 % Intensity on spindle
                pom_export_ios(c,[dir_c filesep 'int_on_spindle'],real_t,res);
            case 5 % Dots
                pom_export_dots(c,[dir_c filesep 'dots'],real_t,res);
        end
    end


end

