function [ ori,mask, answer,xlims,ylims ] = interactive_cell( ori,first_round )


[y,x] = ginput(2); x = round(x); y = round(y);

if first_round
%     xm = round(sum(x)/2);
%     ym = round(sum(y)/2);
%     % crop the image
%     width = round(sqrt(diff(y)^2 + diff(x)^2));
%     xlims = (xm-width):(xm+width);
%     ylims = (ym-width):(ym+width);
%     s = size(ori);
%     % In case its at the edge of the image
%     xlims(xlims>s(1)) = [];
%     xlims(xlims<1) = [];
%     ylims(ylims>s(2)) = [];
%     ylims(ylims<1) = [];
%     % cropped info
%     y = y - ylims(1);
%     x = x - xlims(1);
%     ori = ori(xlims,ylims);
    [ori,xlims,ylims,x,y] = pom_pre_crop_cell(ori,x,y);
else
    xlims = [];
    ylims = [];
end
P = grow_seed( x,y );
[ O,mask ] = grow_cell( ori,P );
close
figure
imshow(ori,[]);
hold on
plot(O(:,2),O(:,1))
answer = questdlg('Segmentation ok?','Click on the x to cancel','Yes','Repeat','Just draw','Yes');
end

