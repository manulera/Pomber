
function [  ] = pom_extraplot( c,name,iscurrent,tpoint )
    
    % New version
    c.extraplot(name,iscurrent,tpoint);
    return

    switch name
    % Spindle
        case 'Spindle: length'
            if isfield(c,'sp')
                extraplot_many(c.sp.len,iscurrent,tpoint)
            end
        case 'Spindle: tubulin intensity profile'
            if isfield(c,'sp')
                extraplot_profile(c.sp.int,iscurrent,tpoint)
            end
        case 'Spindle: length vs. total intensity'
            if isfield(c,'sp')
                extraplot_many(c.sp.tot_int,iscurrent,tpoint,c.sp.len)
            end
        case 'Spindle: length vs. ratio spindle/cell'
            if isfield(c,'sp')
                extraplot_many(c.sp.r_spindle,iscurrent,tpoint,c.sp.len)
            end
        case 'Spindle: intensity background'
            if isfield(c,'sp')
                extraplot_many(c.sp.bg,iscurrent,tpoint)
            end
            
    % Intensity on spindle    
        case 'IOS: intensity profile'
            if isfield(c,'ios')
                extraplot_profile(c.ios.int,iscurrent,tpoint,c.ios.edges)
            end
        case 'IOS: Spindle length vs.total intensity'
            if isfield(c,'ios')
                extraplot_many(c.ios.tot_int2,iscurrent,tpoint,c.sp.len)
            end
        case 'IOS: Spindle length vs. ratio spindle/cell'
            if isfield(c,'sp') && isfield(c,'ios')
                extraplot_many(c.ios.r_int2,iscurrent,tpoint,c.sp.len)
            end    
        case 'IOS: intensity background'
            if isfield(c,'ios')
                extraplot_many(c.ios.bg,iscurrent,tpoint)
            end
        
    % Dots
        case 'Dots: distance'
            if isfield(c,'dots')
                extraplot_many(c.dots.dist,iscurrent,tpoint)
            end
        
    end
end

