function [  ] = pom_showan( c,i,channel )
    
    % See if the channel has some analysis performed
    an_id = c.an_type(channel);
    
    switch an_id
        case 3 % Spindle
            pom_showspindle(c.sp,i)
        case 4 % Spindle intensity
            pom_showspindle(c.sp,i,c.ios.edges(:,i))
        case 5
            pom_showdots(c.dots,i)
    end
end

