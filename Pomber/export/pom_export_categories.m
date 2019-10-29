function [] = pom_export_categories(c, c_dir,h)

    fid=fopen([c_dir filesep 'categories.txt'],'w');
    cats = h.pop_condition_type.String;
    fprintf(fid,cats{c.mitmei+1});
    fclose(fid);
end

