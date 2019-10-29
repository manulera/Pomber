
i = 2;
c = out.cells{end};

%figure; imshow(c.video{1}(:,:,1),[]); [x,y] = getpts();close
%figure; imshow(c.video{1}(:,:,1),[]); [x2,y2] = getpts();close
cont = [y,x];
bigcont = round([y2,x2]);
xlims = round(min(y2):max(y2));
ylims = round(min(x2):max(x2));
figure(1)
while i < 60 
    this = c.video{1}(:,:,i);
    other = c.video{1}(:,:,i-1);
    
    vals = nan(11,11);
    move =-5:5;
    for xx = 1:11
        for yy = 1:11
            mat = (other(xlims,ylims) - this(xlims+move(xx),ylims+move(yy))).^2;
            vals(xx,yy) = sum(mat(:));
        end
    end
    [value, index] = min(vals(:));
    [xx, yy] = ind2sub([11,11], index);
    
    %figure(2)
    %plot(vals)
    
    
    figure(1)
    cont(:,1) = cont(:,1) + move(xx);
    cont(:,2) = cont(:,2) + move(yy);
    xlims = xlims + move(xx);
    ylims = ylims+ move(yy);
    imshow(this,[],'InitialMagnification','fit')
    hold on
    plot(cont(:,2),cont(:,1))
    pause(0.25)
    i = 1 + i;
end