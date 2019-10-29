function [ ] = pom_export_sp( c,dir_sp,time,res )
    
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
        absci_t{t} = linspace(0,c.sp.len(t),numel(c.sp.int{t}))';
        % We do not use mask spindles anymore, but keep the code in case we
        % take them back
        %name = ['mask_t' num2str(t) '.tif'];
        %imwrite(logical(c.sp.mask(:,:,t)),[dir_mask filesep name])
    end
    print_csv_cell(dir_sp,'spindles',{c.sp.spind},[1 1 res res],'.txt')
    print_csv_cell(dir_sp,'contours',{c.sp.cont},[1 1 res res],'.txt')
    print_csv_cell(dir_sp,'absci_int',{absci_t,c.sp.int },[1 1 res res],'.txt')
    print_csv_array( dir_sp,'t_len_dist',[time(:) c.sp.len(:) c.sp.dist(:)],[1 res res],'.txt' )
    print_csv_array( dir_sp,'len_ratio_totint',[c.sp.len(:) c.sp.tot_int(:) c.sp.r_spindle(:)],[res 1 1],'.txt' )


end