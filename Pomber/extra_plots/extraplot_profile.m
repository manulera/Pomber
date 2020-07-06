function [] = extraplot_profile(this_axis,y,iscurrent,tpoint,edges )
    if nargin<5
        edges = [];
    end        
    
    if iscurrent
        
        y = y{tpoint};
        if ~isempty(y)
            plot(this_axis,y','LineWidth',2)
%             if numel(y)>1
%                 xlim([1,numel(y)])
%             end
            ylim(this_axis,[0 inf])
        end
        
        if ~isempty(edges)
            edges = edges(:,tpoint);
            hold(this_axis,'on');
            for j = 1:2
                if ~isnan(edges(j))
                    scatter(this_axis,edges(j),y(edges(j)),'red')
                end
            end
        end        
    end
        


end

