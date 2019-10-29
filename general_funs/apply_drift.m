function [new_video] = apply_drift(video,drift)

    % invert x and y
    drift = drift(2:-1:1,:);
    
    lims = max(drift,[],2)-min(drift,[],2);
    siz = size(video);
    if numel(siz)<4
        siz(4)=1;
    end
    new_video = zeros(siz(1)+lims(1),siz(2)+lims(2),siz(3),siz(4));

    pix_x = min(drift(1,:)):max(drift(1,:));
    zero_x = find(pix_x==0);

    pix_y = min(drift(2,:)):max(drift(2,:));
    zero_y = find(pix_y==0);

    for i = 1:siz(3)
        posx = zero_x + drift(1,i);
        posy = zero_y + drift(2,i);
        new_video(posx:(posx+siz(1)-1),posy:(posy+siz(2)-1),i,:)=video(:,:,i,:);
    end
    
end