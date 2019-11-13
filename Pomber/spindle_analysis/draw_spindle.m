function [ spind ] = draw_spindle( ima,contrast,spind,x_bound,y_bound,open_figure)

    if nargin<6
        open_figure=true;
    end

    if open_figure
        figure()
    end
    imshow(ima,contrast,'InitialMagnification','fit');
    hold on
    xlim(x_bound([1,end]))
    ylim(y_bound([1,end]))
    plot(spind(:,1),spind(:,2),'cyan')
    
    [xx,yy] = getpts();
    if ~isempty(xx)
        % Transposition is a bit annoying
        x = xx; y = yy;
        spind = [x(:) y(:)];
    end
    if open_figure
        close
    end
end

