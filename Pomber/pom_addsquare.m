function [h] = pom_addsquare(h)

    axes(h.ax_main)
    [x,y] = getpts();
    h.squares= [h.squares [x,y;x(1),y(1)]];
end

