function [x,y] = draw_dots(ima,contrast)
        figure
        imagesc(ima,contrast)
        axis equal
        [y,x] = ginput(2);
        close
end

