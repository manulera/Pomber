
function [  ] = pom_extraplot( c,name,iscurrent,tpoint,this_axis )
    
    % New version
    c.extraplot(this_axis,name,iscurrent,tpoint);
    return

    switch name
    % Spindle
        case 'Spindle: length'
            if isfield(c,'sp')
                extraplot_many(this_axis,c.sp.len,iscurrent,tpoint)
            end
        case 'Spindle: tubulin intensity profile'
            if isfield(c,'sp')
                extraplot_profile(this_axis,c.sp.int,iscurrent,tpoint)
            end
        case 'Spindle: length vs. total intensity'
            if isfield(c,'sp')
                extraplot_many(this_axis,c.sp.tot_int,iscurrent,tpoint,c.sp.len)
            end
        case 'Spindle: length vs. ratio spindle/cell'
            if isfield(c,'sp')
                extraplot_many(this_axis,c.sp.r_spindle,iscurrent,tpoint,c.sp.len)
            end
        case 'Spindle: intensity background'
            if isfield(c,'sp')
                extraplot_many(this_axis,c.sp.bg,iscurrent,tpoint)
            end
            
    % Intensity on spindle    
        case 'IOS: intensity profile'
            if isfield(c,'ios')
                extraplot_profile(this_axis,c.ios.int,iscurrent,tpoint,c.ios.edges)
            end
        case 'IOS: Spindle length vs.total intensity'
            if isfield(c,'ios')
                extraplot_many(this_axis,c.ios.tot_int2,iscurrent,tpoint,c.sp.len)
            end
        case 'IOS: Spindle length vs. ratio spindle/cell'
            if isfield(c,'sp') && isfield(c,'ios')
                extraplot_many(this_axis,c.ios.signal_length,iscurrent,tpoint)
            end    
        case 'IOS: intensity background'
            if isfield(c,'ios')
                extraplot_many(this_axis,c.ios.bg,iscurrent,tpoint)
            end
        
    % Dots
        case 'Dots: distance'
            if isfield(c,'dots')
                extraplot_many(this_axis,c.dots.dist,iscurrent,tpoint)
            end
        
    end
end

