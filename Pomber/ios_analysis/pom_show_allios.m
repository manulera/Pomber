function [  ] = pom_show_allios( spin,edges,sizes,rows,cols )
for i =1:sizes(3)
    
    [ro,co] = ind2sub([rows,cols],i);
    cor1 = sizes(2)*(co-1);
    cor2 = sizes(1)*(ro-1);
    spin{i}(:,2) = spin{i}(:,2) +cor1;
    spin{i}(:,1) = spin{i}(:,1) +cor2;
    % Wee add it already here for clarity of the function
    plot(spin{i}(:,2),spin{i}(:,1),'cyan','LineWidth',1)
    
    e = edges(:,i);
    if ~isempty(e)
        for j = 1:2
            if ~isnan(e(j))
                scatter(spin{i}(e(j),2),spin{i}(e(j),1),'yellow')
                scatter(spin{i}(e(j),2),spin{i}(e(j),1),'yellow')
            end
        end
    end
    
end
end

