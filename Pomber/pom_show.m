function [] = pom_show( handles )
% This function is called whenever we change something that will affect the
% information displayed as image, graphs, values, etc. 

% Show the frame for t=handles.currentt, z=handles.currentz

%% Main axes
this_axis = handles.ax_main;
cla(this_axis);
hold(this_axis,'off');

if handles.toggled ~= 4
    imshow(handles.video{handles.toggled}(:,:,handles.currentt),handles.im_info.contrast(handles.toggled,:),'Parent',this_axis)
else
    pom_show_merge(this_axis,handles);
    
end
hold(this_axis,'on');

for i =1:numel(handles.cells)
    if ismember(i,handles.frame_list{handles.currentt})
        handles.cells{i}.displaySquare(this_axis,'red',handles.currentt);
    end
end

for i = 1:numel(handles.squares)
    if ~isempty(handles.squares{i})
        plot(handles.squares{i}(:,1),handles.squares{i}(:,2),'cyan','LineWidth',2)
    end
end

%% Time value
t_str = datestr(seconds(handles.time(handles.currentt)),'HH:MM:SS');
tp_str = [num2str(handles.currentt) ' / ' num2str(handles.tlen)];
handles.text_time.String = [handles.pos_name ' - Timepoint: ' tp_str ' - ' t_str ' - ' num2str(numel(handles.cells)) ' cells'];

%% Display the limits of the intensity
if handles.toggled ~=4
    handles.int_limit_low.String=handles.im_info.contrast(handles.toggled,1);
    handles.int_limit_high.String=handles.im_info.contrast(handles.toggled,2);
end

if handles.tog_fastscroll.Value
    return
end


% Check at the end rather than checking in iteration
if ismember(handles.currentcell,handles.frame_list{handles.currentt})
    this_cell = handles.cells{handles.currentcell};
    this_cell.displaySquare(this_axis,'green',handles.currentt);
%% Closeup axes    
    % Now update the close up
    % 1 when there is only one fluo, 2 when there is merge
    nb_channels = numel(handles.video);
    if nb_channels==2
        channels2show = 2;
    else
        channels2show = 4;
    end
    
    for j = 1:channels2show
        this_axis = handles.(['ax_closeup' num2str(j)]);
        hold(this_axis,'off');
        cla(this_axis);
        if j~=4
%             ima = handles.video{j}(:,:,handles.currentt);
            this_cell.displayCloseUp(this_axis,handles.small_video,handles.currentt,j,handles.im_info.contrast(j,:));
        else
            
            this_cell.displayCloseUp(this_axis,handles.small_video,handles.currentt,4,[]);
        end
    end
%% Extra axis
    
    for ax =1:2
        ii = handles.(['pop_ex' num2str(ax)]).Value;
        name = handles.(['pop_ex' num2str(ax)]).String{ii};
        if ii>1
            this_axis = handles.(['ax_extra' num2str(ax)]);
            reset(this_axis);
            cla(this_axis);
            hold(this_axis,'off');
            for i = 1:numel(handles.cells)
                pom_extraplot(handles.cells{i},name,i==handles.currentcell,handles.currentt,this_axis)
            end
        end
        
    end

end
