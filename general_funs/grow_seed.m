function [ P ] = grow_seed( x,y )
    
    excent = 0.97; % This is a good parameter for the initial elipse
    elipse_npoints = 200; % This is a reasonable number of points
    [xx,yy] = make_elipse( x,y,excent,elipse_npoints);
    % ori is a crop of the original image
    P = [xx',yy'];

end

