function [  ] = extraplot_many( this_axis,y,iscurrent,tpoint,x,category )
    if nargin<5||isempty(x)
        x = 1:numel(y);
    end
    hold(this_axis,'on');
    if iscurrent
        lw = 2;
        %cl = 'red';
    else
        lw = 1;
        %cl = 'blue';
    end
    cl = get(this_axis,'colororder');
    cl = cl(category,:);
    a = plot(this_axis,x,y,'LineWidth',lw,'Color',cl);
    
    if iscurrent
        scatter(this_axis,x(tpoint),y(tpoint),'MarkerFaceColor','k','MarkerEdgeColor',cl)
    else
        a.Color(4) = 0.5;
    end

end

