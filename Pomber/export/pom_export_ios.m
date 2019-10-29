function [ ] = pom_export_ios( c,dir_ios,time,res )
    
    % Is directory 
    if ~isdir(dir_ios)
        mkdir(dir_ios)
    end
    
    nb_tps = numel(time);
    absci_t = cell(1,nb_tps);
    for t = 1:nb_tps
        absci_t{t} = linspace(0,c.sp.len(t),numel(c.sp.int{t}))';
    end
    print_csv_cell(dir_ios,'absci_int',{absci_t,c.ios.int },[1 1 res res],'.txt')
    print_csv_array(dir_ios,'len_ratio_totint',[c.sp.len(:) c.ios.r_int2(:) c.ios.tot_int2(:)],[res 1 1],'.txt' )
end