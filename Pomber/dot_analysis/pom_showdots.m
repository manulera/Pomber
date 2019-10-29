function [ ] = pom_showdots( dots,i )
    hold on
    scatter(dots.coords{i}(:,2),dots.coords{i}(:,1),'yellow','LineWidth',2)
end

