function [x,y,keep_mask] = cutSpindlePoly(spindle_prob,pars,spindle_mask_thresh)
    
    % Decide which range of the polynomium represents the spindle based
    % on the mask spindle_mask
    
    
    % The range might depend, but 200 should be enough for any spindle
    x =-200:200;
    y = x.^2*pars(4);
    
    [x,y]=rotateNCenter(x,y,pars);

    mask = spindle_prob>spindle_mask_thresh;
    
    [keep_polygon,keep_mask] = intersectLineMask(x,y,mask);

    x = x(keep_polygon);
    y = y(keep_polygon);
    %% Plot the result
    
    
%     figure
%     showmask = bwconvhull(keep_mask);
%     [~,x_c,y_c]=makeSmallVideo(showmask,showmask,0.6);
%     imshow(mask,[])
%     xlim(x_c([1,end]))
%     ylim(y_c([1,end]))
%     hold on
%     plot(x,y)
%     scatter(pars(2),pars(3))
%     pause(0.5)

end

