function [] = dlmcell( filename,input, delim )
    if nargin<3
        delim = ',';
    end
    fid=fopen(filename,'w');
    csvFun = @(str)sprintf(['%s' delim],str);
    
    for i = 1:size(input,1)
        xchar = cellfun(csvFun, input(i,:), 'UniformOutput', false);
        xchar = strcat(xchar{:});
%       Better to do this simply before feeding the path
%         if ispc
%             xchar = process_path_pc(xchar);
%         end
        xchar = strcat(xchar(1:end-1),'\n');
        fprintf(fid,xchar);
    end
    
    fclose(fid);
end

