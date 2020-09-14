% load pomber_save.mat
%%


i=1;    
this_cell = handles.cells{i};
int=this_cell.features{2}.int;
edges=this_cell.features{2}.edges;
anaphase_start = round(this_cell.features{3}.length_fit(2));

for j = anaphase_start:size(edges,1)

    figure;
    imshow(int{j},[],'InitialMagnification','Fit')
    hold on
    vline(edges(j,:),'y')
end
%%    
ios=this_cell.features{2}
