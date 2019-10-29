function [h] = pom_update_pos_names(h)
    h.all_pos_names = ReadndFile(h.pathfile, h.ndfile);
end

