function [pars] = findSpindlePoly(ima,cell_mask,second_degree,spindle_prob)
    % Fits the points in either the cell mask or the spindle mask to a
    % polynomium of 1 or 2 degree (as indicated by logical variable 
    % second_degree). Returns a polynomium on the form (angle,px,py,
    % second_order exponent).
    
    %% Argument handling and parameters to be set
    
    if nargin<3||isempty(spindle_prob)
        has_spindle_mask =false;
        spindle_prob=[];
        use_spindle_mask_for_guess = false;
    else
        has_spindle_mask =true;
        % You can set up this
        use_spindle_mask_for_guess = true;
        spindle_mask_thresh = 0.8;
    end

    %% Calculating an initial guess for the fit
    if has_spindle_mask && use_spindle_mask_for_guess
        guess_mask = cell_mask.*(spindle_prob>spindle_mask_thresh);
        if ~any(guess_mask(:))
            % Try only twice
            % TODO: This should be a parameter
            guess_mask = cell_mask.*(spindle_prob*0.6>spindle_mask_thresh);
            if ~any(guess_mask(:))
                guess_mask = cell_mask.*(spindle_prob*0.6>spindle_mask_thresh);
            else
                guess_mask = cell_mask;
            end
            
        end
    else
        guess_mask = cell_mask;
    end
    
    lis = regionprops(guess_mask,ima,'PixelList','PixelValues');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    zz = lis.PixelValues;
    
    % bg is the background calculated as the median, should be enough
    
    if use_spindle_mask_for_guess
        bg=0;
    else
        bg = median(zz);
    end
    
    % We find the center of mass, to suggest as point for the fit
    zz_b = zz-bg;
    xc = sum(xx.*(zz_b))/sum(zz_b);
    yc= sum(yy.*(zz_b))/sum(zz_b);
    
    lis = regionprops(guess_mask,'Orientation');
    sugg_ang = -deg2rad(lis.Orientation);
    
    %% Fitting
    % TODO: This should be a parameter
    if second_degree
        [spb_1,spb_2]=findDotsInMovie(ima,cell_mask);
        pars=weightedOrthogonalFitConstrained(ima,guess_mask,bg,spb_1,spb_2,1);
        pars = convertParabollaFit2OldFit(spb_1,spb_2,pars);
    else
        [pars] = weightedOrthogonalFit(ima,guess_mask,bg,[sugg_ang,xc,yc,0],second_degree,1);
    end
    
    %% To plot the result
    
%     x =-170:170;
%     y = x.^2*pars(4);
%     theta = -pars(1);
%     R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
%     coords = [x; y]' * R;
%     x = coords(:,1);
%     y = coords(:,2);
%     x = x+pars(2);
%     y = y+pars(3);
%     
%     figure
%     [~,x_c,y_c]=makeSmallVideo(ima,cell_mask,0.6);
%     imshow(ima,[])
%     xlim(x_c([1,end]))
%     ylim(y_c([1,end]))
%     hold on
%     plot(x,y)
%     scatter(pars(2),pars(3))
%     scatter(xc,yc)
%     pause(0.2)
    
    
end

