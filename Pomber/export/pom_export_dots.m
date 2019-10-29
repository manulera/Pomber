function [  ] = pom_export_dots( c,dir_dots,time,res )
    
    % Is directory 
    if ~isdir(dir_dots)
        mkdir(dir_dots)
    end

    %intensity = [dir_dots filesep 'intensity.txt'];
    
    
    print_csv_cell(dir_dots,'coords',{c.dots.coords},[1 1 res res],'.txt')
    
    dir_pix = [dir_dots filesep 'in_pix'];
    if ~isdir(dir_pix)
        mkdir(dir_pix)
    end
    
    print_csv_array(dir_dots,'t_dist',[time(:) c.dots.dist(:)],[1 res],'.txt' )
end
