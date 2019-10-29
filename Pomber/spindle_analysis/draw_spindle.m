function [ spind ] = draw_spindle( ima,contrast,spind,open_figure)

    if nargin<4
        open_figure=true;
    end

    if open_figure
        figure()
    end
    imshow(ima,contrast,'InitialMagnification','fit');
    hold on
    plot(spind(:,2),spind(:,1),'cyan')
    [xx,yy] = getpts();
    if ~isempty(xx)
        % Transposition is a bit annoying
        x = xx; y = yy;
        spind = [y(:) x(:)];
    end
    if open_figure
        close
    end
end

