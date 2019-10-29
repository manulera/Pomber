function [ handles ] = pom_selectcell( handles )

DIC = find(handles.an_type==2);
if isempty(DIC)
    warndlg('You must specify which is the DIC channel')
    uiwait
    return
elseif numel(DIC)>1
    warndlg('Only one channel can be specified as DIC')
    uiwait
    return
end

axes(handles.ax_main)
first_round = true;
ori = handles.video{DIC}(:,:,handles.currentt);
if handles.pop_cell_selection_method.Value == 1
    [x,y] = getpts();
    if numel(x)~=2
        return
    end
    [ori,xlims,ylims] = pom_pre_crop_cell(ori,y,x);
    [ mask ] = draw_cell( ori);
    if ~any(mask)
        return
    end
    repeat = false;
    store = true;
else
    repeat = true;
end
    
while repeat == true
    if first_round
        [ ori,mask, answer,xlims,ylims ] = interactive_cell( ori,first_round);
        first_round = false;
    else
        [ ori,mask, answer] = interactive_cell( ori,first_round);    
    end
    switch answer
        case 'Yes'
            store = true;
            repeat = false;
        case 'Repeat'
            
        case 'Just draw'
            [ mask ] = draw_cell( ori);
            repeat = false;
            store = true;
    end    
end

    if store
        % Inibox is just to show in the big picture which is the cell
        % we are analyzing
        [ ini_box,out ] = crop_cell( mask );
        ini_box(:,2) = ini_box(:,2) + xlims(1);
        ini_box(:,1) = ini_box(:,1) + ylims(1);

        out.contrast = handles.im_info.contrast;
        out.currentt = handles.currentt;
        out.tlen = handles.tlen;
        out.dic = DIC;
        mini_video = cell(size(handles.video));
        % In case we want to implement the cell movement
        %out.xmain = xlims;
        %out.ymain = ylims;
        
        for i = 1:numel(handles.video)
            mini_video{i} = handles.video{i}(xlims,ylims,:,:);
        end
        out.video = rotate_video(mini_video,out.xlims,out.ylims,out.angle);
        newcell = CellProfile(out);
        % If you close without clicking on "done"
        if isempty(newcell)
            return
        end
        newcell = pom_complete_nucell(newcell,handles,out.dic);
        newcell.ini_box = ini_box;
        newcell.xmain = xlims;
        newcell.ymain = ylims;
        newcell = cellu(newcell);
        handles = pom_addcell( handles, newcell );
    end
end

