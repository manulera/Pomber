function [ c ] = pom_anany( c,channel,type,im_info )
    
    switch type
        case 3 % Spindle
            c.features{channel} = f_spindle(c);
        case 4 % Spindle intensity
            repeat = 1;
            c = pom_anint(c,channel,im_bg,repeat);
        case 5 % Dots
            c.features{channel}=f_dots(c);            
    end
    c = c.find_feature(channel,im_info);    
end

