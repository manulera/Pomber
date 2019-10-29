
figure
hold on
for i = [15,21,22]
    ima = c.video{2}(:,:,i);
    mask = c.masks(:,:,i);
    ii = find(ima.*mask);
    histogram(ima(ii))
end