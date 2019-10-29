function [ c ] = pom_anthis_dots( c,channel,t,coords )
    i = find(c.list==t);
    if nargin<4
        ima = c.video{channel}(:,:,i).*c.masks(:,:,i);
        figure
        imagesc(ima)
        axis equal
        [y,x] = ginput(2);
        close
        c.dots.coords{i} = [x(:) y(:)];
    else
        c.dots.coords{i} = coords;
    end
    
    c.dots.dist(i) = sqrt(sum(diff(c.dots.coords{i}).^2));
    
    
end

