function [ handles ] = pom_analyze( handles,isall)

if nargin<2
    isall=false;
end

% Spindle, intensity on spindle and dots
for j =3:5
    channel = find(handles.an_type==j);
    if numel(channel)==1
        % If its analyze all, then do the whole list
        if isall
            dolist = 1:numel(handles.cells);
        % If its only this one
        else
            dolist = handles.currentcell;
        end
        
        for i = dolist
            % Check if analyzed already, otherwise skip
            
            dothis = ~any(handles.cells{i}.an_type==j);

            if dothis
                handles.cells{i}.find_feature(channel,j,handles.im_info);
            end

        end
        
    elseif numel(channel)>1
        warndlg(['Two or more channels specified as' handles.pop_c1.String{j}])
        uiwait
        return
    end
end    


end

