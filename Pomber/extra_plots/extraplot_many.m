function [  ] = extraplot_many( y,iscurrent,tpoint,x,category )
    if nargin<4||isempty(x)
        x = 1:numel(y);
    end
    hold on
    if iscurrent
        lw = 2;
        %cl = 'red';
    else
        lw = 1;
        %cl = 'blue';
    end
    cl = get(gca,'colororder');
    cl = cl(category,:);
    a = plot(x,y,'LineWidth',lw,'Color',cl);
    
    if iscurrent
        scatter(x(tpoint),y(tpoint),'MarkerFaceColor','k','MarkerEdgeColor',cl)
    else
        a.Color(4) = 0.2;
    end

end

