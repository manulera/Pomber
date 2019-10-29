function [weight] = weightFunctionAngleCurve(ima,mask,bg,pars,second_degree)
    

    lis = regionprops(mask,ima,'PixelList','PixelValues');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    zz = lis.PixelValues;
    
    % Rotation matrix
    theta = pars(1);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    
    % Center at the point
    xx = xx-pars(2);
    yy = yy-pars(3);
    
    % Rotate
    coords = [xx yy] * R;
    
    xx = coords(:,1);
    yy = coords(:,2);
    
    
    if second_degree
        expected = pars(4)*xx.^2;
    else
        expected = 0;
    end
    
    intens_diff = zz-bg;
    sign = (intens_diff>0)*2-1;
    
    weight = (abs(expected-yy).*(zz-bg).^2 + 0.1*abs(xx)).*sign;
    weight = sum(weight);
end

