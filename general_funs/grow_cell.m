function [ O,bigmask ] = grow_cell( ori,P,iterations)
% We divide by the median to increase contrast (Also the snakes only work
% with max intensity equal to 1)
if nargin<3
    iterations = false;
end

I = imcomplement(imgaussfilt(imgradient(ori/median(ori(:))),2));
Options = default_snake();
if iterations
    Options.Iterations = iterations;
    Options.Verbose = false;
end
[O,bigmask]=Snake2D(I,P,Options);
end