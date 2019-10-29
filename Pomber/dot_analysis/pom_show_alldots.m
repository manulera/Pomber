function [  ] = pom_show_alldots( c,sizes,rows,cols )
for i =1:sizes(3)
    [ro,co] = ind2sub([rows,cols],i);
    cor1 = sizes(2)*(co-1);
    cor2 = sizes(1)*(ro-1);
    scatter(c{i}(:,2)+cor1,c{i}(:,1)+cor2,'red')
end
end

