function [] = pom_show_allspind( s,c,sizes,rows,cols )
for i =1:sizes(3)
    [ro,co] = ind2sub([rows,cols],i);
    cor1 = sizes(2)*(co-1);
    cor2 = sizes(1)*(ro-1);
    plot(s{i}(:,2)+cor1,s{i}(:,1)+cor2,'cyan')
    if ~isempty(c{i})
        h = plot(c{i}(:,2)+cor1,c{i}(:,1)+cor2,'yellow');
    end
    h.Color(1,4) = 0.3;
end
end

