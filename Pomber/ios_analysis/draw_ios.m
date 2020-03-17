function [mask] = draw_ios(ima,contrast,mask,x_bound,y_bound,open_figure)

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
    
    
    
    cont = bwboundaries(mask);            
    for j = 1:numel(cont)
        x = cont{j}(:,2);
        y = cont{j}(:,1);
        p=plot(x,y,'blue','LineWidth',1);
        
    end
    
    
    imsize = size(ima);
    
    [xx,yy] = getpts();
    if ~isempty(xx)
        mask = poly2mask(xx,yy,imsize(1),imsize(2));
    end
    if open_figure
        close
    end
end



