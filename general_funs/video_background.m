function [ bg ] = video_background( video )

bg = nan(size(video,3),1);
barry = waitbar(0,'Getting the background of images');
vid_len = numel(bg);
for i = 1:vid_len
    waitbar(i/vid_len)
    bg(i) = image_background(video(:,:,i));
end
close(barry)
end

