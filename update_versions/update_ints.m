function [ handles ] = update_ints( handles )
    for i =1:numel(handles.cells) 
        for j = 1:numel(handles.cells{i}.list)
            handles.cells{i}.sp.int{j} = handles.cells{i}.sp.int{j}(:);
            handles.cells{i}.ios.int{j} = handles.cells{i}.ios.int{j}(:);
            handles.cells{i}.ios.int2{j} = handles.cells{i}.ios.int2{j}(:);
        end
    end
end

