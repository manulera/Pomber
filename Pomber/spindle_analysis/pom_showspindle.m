function [  ] = pom_showspindle( sp,i,edges )
    
    color = 'red';
    
    if nargin<3
        edges = [];
    end
    hold on
    plot(sp.spind{i}(:,2),sp.spind{i}(:,1),color,'LineWidth',1)
    if ~isempty(edges)
        for j = 1:2
            if ~isnan(edges(j))
                scatter(sp.spind{i}(edges(j),2),sp.spind{i}(edges(j),1),'yellow')
                scatter(sp.spind{i}(edges(j),2),sp.spind{i}(edges(j),1),'yellow')
            end
        end
    end
    %plot(sp.cont{i}(:,2),sp.cont{i}(:,1),'yellow','LineWidth',1)
end

