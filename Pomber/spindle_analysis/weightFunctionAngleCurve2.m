function [weight] = weightFunctionAngleCurve2(ima,mask,bg,pars,second_degree)
    

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
    weight = sign.*(intens_diff).^2.*(exp(-abs(expected-yy)/10) -0.001*abs(xx));
%     weight = (zz-bg).^2.*exp(-abs(expected-yy)/10);
    weight = -sum(weight) ;
end

