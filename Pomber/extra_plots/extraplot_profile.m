function [] = extraplot_profile(y,iscurrent,tpoint,edges )
    if nargin<4
        edges = [];
    end        
    if iscurrent
        y = y{tpoint};
        if ~isempty(y)
            plot(y,'LineWidth',2)
            if numel(y)>1
                xlim([1,numel(y)])
            end
            ylim([0 inf])
        end
        
        if ~isempty(edges)
            edges = edges(:,tpoint);
            hold on
            for j = 1:2
                if ~isnan(edges(j))
                    scatter(edges(j),y(edges(j)),'red')
                end
            end
        end        
    end
        


end

