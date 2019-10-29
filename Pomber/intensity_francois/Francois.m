close all
x = [36 65]';
y = [38.8783,16]';
siz = [55   105];
[dis,pos] =line_indices(siz,[y x]);

figure
imshow(pos>=0 & pos<1,[],'InitialMagnification','fit')
hold on
plot(x,y)

figure
imagesc(abs(dis))
axis equal
hold on
plot(x,y)

figure
imagesc(abs(pos))
axis equal
hold on
plot(x,y)
