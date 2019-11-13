function [ handles ] = pom_anthis( handles,onstack )
if nargin<2
    onstack=false;
end
if ismember(handles.currentcell,handles.frame_list{handles.currentt})
    if onstack
%         stacks = {};
%         for i = 1:numel(handles.channel_names)
%             stacks = [stacks dir([handles.pathfile, handles.ndfile(1:end-3) '*' '_w' num2str(i) '*_s' num2str(handles.pos_index) '_t' num2str(handles.currentt) '.TIF'])];
%         end
%         handles.cells{handles.currentcell} = handles.cells{handles.currentcell}.correct_onstack(handles.currentt,handles.im_info,stacks);
        
    else
        handles.cells{handles.currentcell}.correct(handles.video,handles.currentt,handles.im_info,handles.extra);
    end

%     switch handles.an_type(i)
%         case 3 % Spindle
%             handles.cells{handles.currentcell} = pom_anthis_spindle(handles.cells{handles.currentcell},i,handles.currentt,handles.resolution,handles.im_bg(:,i));
%             % If there is ios, repeat it with the new spindle
%             if any(handles.an_type==4)
%                 ios_channel = find(handles.an_type==4);
%                 c = handles.cells{handles.currentcell};
%                 ind = find(c.list==handles.currentt);
%                 c.ios.edges(:,ind) = nan(2,1);
%                 c = pom_correct_ios(c,ios_channel,ind);
%                 handles.cells{handles.currentcell} = pom_anthis_ios(c,ios_channel,ind,handles.im_bg(:,i),true);
%             end
%         case 5 % Dots
%             handles.cells{handles.currentcell} = pom_anthis_dots(handles.cells{handles.currentcell},i,handles.currentt);
%     end
%     end
    
end
end