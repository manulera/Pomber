
i = 1;

for i = 1:24
ima = cut_video(:,:,i);
mask = cell_masks(:,:,i);

lis = regionprops(mask,ima,'PixelList','PixelValues');
xx = lis.PixelList(:,1);
yy = lis.PixelList(:,2);
zz = lis.PixelValues;

% Histogram
% figure
% histogram(zz);

bg = image_background(zz);
[bg,median(zz)]
[~,x_bound,y_bound]=makeSmallVideo(ima,mask,0.5);

% figure
% imshow(ima.*mask,[])
% hold on
% xlim(x_bound([1,end]))
% ylim(y_bound([1,end]))
% 
% [x,y] = getpts();
% 
% BW = roipoly(ima.*mask,x,y);
% 
% figure;
% imshow(BW)
% xlim(x_bound([1,end]))
% ylim(y_bound([1,end]))
% 
% sum(ima(BW)-bg)

spin_mask = self.masks(:,:,i);
if any(spin_mask(:))
    cont = bwboundaries(spin_mask);
    cont = cont{1};
else
    cont = [nan,nan];
end

figure;
subplot(1,2,2);
imshow(ima.*mask,[500,1000])
hold on
xlim(x_bound([1,end]))
ylim(y_bound([1,end]))

plot(cont(:,2),cont(:,1))

subplot(1,2,1);
imshow(ima.*mask<bg)
hold on
xlim(x_bound([1,end]))
ylim(y_bound([1,end]))
plot(cont(:,2),cont(:,1))

end
    



