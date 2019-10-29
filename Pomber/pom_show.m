function [] = pom_show( handles )
% This function is called whenever we change something that will affect the
% information displayed as image, graphs, values, etc. 

% Show the frame for t=handles.currentt, z=handles.currentz

%% Main axes
axes(handles.ax_main)
hold off
cla
if handles.toggled ~= 4
    imshow(handles.video{handles.toggled}(:,:,handles.currentt),handles.im_info.contrast(handles.toggled,:))
else
    ima = squeeze(handles.video{handles.toggled}(:,:,handles.currentt,:));
    imshow(ima);
end
hold on
% for ind_cell = handles.frame_list{handles.currentt}
%     handles.cells{ind_cell}.display_square('red');
% end
for i =1:numel(handles.cells)
    handles.cells{i}.display_square('red');
end

for i = 1:numel(handles.squares)
    if ~isempty(handles.squares{i})
        plot(handles.squares{i}(:,1),handles.squares{i}(:,2),'cyan','LineWidth',2)
    end
end
if handles.tog_fastscroll.Value
    return
end


% Check at the end rather than checking in iteration
if ismember(handles.currentcell,handles.frame_list{handles.currentt})
    this_cell = handles.cells{handles.currentcell};
    this_cell.display_square('green');
%% Closeup axes    
    % Now update the close up
    % 1 when there is only one fluo, 2 when there is merge
    dummy = numel(handles.video)/2;
    i_logic = handles.currentt==this_cell.list;
    ind_cell = find(i_logic);
    for j = 1:(dummy*2)
        axes(handles.(['ax_closeup' num2str(j)]))
        hold off
        cla
        if j~=4
            imshow(this_cell.video{j}(:,:,ind_cell),handles.im_info.contrast(j,:))
            this_cell.display_closeup(ind_cell,j);
%             if j ==3
%                 this_cell.display_closeup(ind_cell,j-1);
%             end
                
        % If you created the merge channel after this small cell was
        % created
        elseif numel(this_cell.video)>=j
            imshow(squeeze(this_cell.video{j}(:,:,ind_cell,:)))
        end
    end
%% Extra axis
    for ax =1:2
        ii = handles.(['pop_ex' num2str(ax)]).Value;
        name = handles.(['pop_ex' num2str(ax)]).String{ii};
        if ii>1
            axes(handles.(['ax_extra' num2str(ax)]))
            reset(gca);cla;hold off
            for i = 1:numel(handles.cells)
                pom_extraplot(handles.cells{i},name,i==handles.currentcell,ind_cell)
                
            end
        end
    end

end
%% Time value
t_str = datestr(seconds(handles.time(handles.currentt)),'HH:MM:SS');
tp_str = [num2str(handles.currentt) ' / ' num2str(handles.tlen)];
handles.text_time.String = ['Timepoint: ' tp_str ' - ' t_str];

%% Display the limits of the intensity
if handles.toggled ~=4
    handles.int_limit_low.String=handles.im_info.contrast(handles.toggled,1);
    handles.int_limit_high.String=handles.im_info.contrast(handles.toggled,2);
end
