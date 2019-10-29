function [ bg ] = video_background( video )

bg = nan(size(video,3),1);
barry = waitbar(0,'Getting the background of images');
vid_len = numel(bg);
for i = 1:vid_len
    waitbar(i/vid_len)
    % No longer needed @TODO remove
    %     bg(i) = image_background(video(:,:,i));
    bg(i)=0;
end
close(barry)
end

