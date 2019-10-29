function [h] = pom_change_pos(h)
    index = listdlg('ListString',h.all_pos_names,'SelectionMode',...
        'single','PromptString',{'Select the position ', 'you want to open'});
    if ~isempty(index)
        h.pos_index = index;
    else
        return
    end
    h.pos_name= h.all_pos_names{h.pos_index};
    path1 = [h.pathfile filesep 'pomber_analysis'];
    path2 = [path1 filesep h.pos_name];
    if isdir(path1) && isdir(path2) && isfile([path2 filesep 'pomber_save.mat'])
        h = pom_load(h,path2,'pomber_save.mat');
    else
        h = pom_init(h,1);
        h = pom_import(h,1);
    end
end

