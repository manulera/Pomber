function [ x,y ] = cut_line( x,y,xx,yy,thresh )
% When we fit a line to a vloud of points, if its almost a vertical line
% the extremes of the line are clearly outside of the cloud of points, this
% cuts a line keeping only the points that are really inside of the line

if nargin<4
    thresh = 1;
end

all_dis = nan(numel(x),numel(yy));
for i = 1:numel(x)
all_dis(i,:) = (xx-x(i)).^2 + (yy-y(i)).^2;
end
keep = min(all_dis,[],1)<thresh.^2;

x = xx(keep);
y = yy(keep);

end

