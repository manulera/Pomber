function [ thiscell ] = pom_complete_nucell( thiscell,handles,dic_chan )
    
    % Initialize useful variables of the new cell
    % Contains which analysis has been performed on the cell per channel
    thiscell.an_type = ones(1,numel(handles.an_type));
    thiscell.an_type(dic_chan) = 2;
    thiscell.mitmei = 0;
    thiscell = pom_ask_mitmei(thiscell,handles.pop_condition_type.String);
end

