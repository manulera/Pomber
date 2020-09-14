%% Load your handles for the example

% Select a cell from the list
this_cell = handles.cells{1};

% Select a time point for the cell, then get the one corresponding in the
% movie
time_point_cell = 30;
time_point_movie = this_cell.list(time_point_cell);

ima = handles.video{3}(:,:,time_point_movie);
cell_mask = this_cell.masks(:,:,time_point_cell);

% Boundign box of the cell
box= regionprops(cell_mask, 'BoundingBox'); 
box = box.BoundingBox;

% Contour of the cell
cont = bwboundaries(cell_mask);
cont = cont{1};

% Get the elements from the spindle feature

sp_feature = this_cell.features{3};

% See spindleLinescan
x = sp_feature.spind{time_point_cell}(:,1);
y = sp_feature.spind{time_point_cell}(:,2);
fit = sp_feature.spindle_trace_fit(time_point_cell,:);
p = defaultSpindleParameters();
[xx,yy]=makeParallelCurves(x,y,fit,p.total_width,1);

% Here we make a logical array that is true for the lines we consider as
% signal

signal = p.center_line-p.signal_width:p.center_line+p.signal_width;
background = false(1,p.total_width*2+1);
bg1 = p.center_line-p.signal_width-1;
bg2 = p.center_line+p.signal_width+1;
background=[bg1-p.background_width bg1 bg2 bg2+p.background_width];

figure
imshow(ima,[100,180])
hold on
xlim([box(1),box(1)+box(3)])
ylim([box(2),box(2)+box(4)])
plot(cont(:,2),cont(:,1),'y','LineWidth',2)

plot(x,y,'blue','LineWidth',2)

for i = signal([1,end])
    plot(xx(i,:),yy(i,:),'g','LineWidth',2)
end

for i = background
    plot(xx(i,:),yy(i,:),'magenta','LineWidth',2)
end






