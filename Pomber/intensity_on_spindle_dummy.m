function [ int,tot_int,ratio,cell_bg ] = intensity_on_spindle( ima,s,cell_mask,edges)
    if nargin<4
        edges = [];
    end
    % Length of the line
    len = sum(sqrt(sum(diff(s).^2,2)));
    % Resample so that it has as many points as pixels
    s2 = resamplePolyline(s,ceil(len));
    % Intensity profile along the spindle line
    [int,spind_mask] = thicc_profile(ima,s2(:,2),s2(:,1),3);
    
    edge_mask = spind_mask;
    if ~isempty(edges) && ~any(isnan(edges))
        lims = [1 numel(s2)];
        for i = 1:2
            if ~isnan(edges(i))
                lims(i) = edges(i);
            end
        end
        lims = lims(1):lims(2);
        [~,edge_mask] = thicc_profile(ima,s2(lims,2),s2(lims,1),3);
    end
    if nargout>1
    % Mask containing the area where the intensity of the spindle
    % is measured
    in_mask = spind_mask.*cell_mask.*edge_mask;
    % Mask containing the surface of the cell without the spindle
    out_mask = ~spind_mask.*cell_mask;

    % How to calculate the background??
    bgg = ima.*out_mask;
    cell_bg = image_background(bgg(bgg~=0));

    bg_mask = ima>cell_bg;
    substract_cell_bg = true;
    
    if substract_cell_bg
        ima = ima-cell_bg;
    end

    % Intensity inside in_mask
    in_int = sum(sum(ima.*in_mask.*bg_mask));
    % Intensity inside out_mask
    out_int= sum(sum(ima.*out_mask.*bg_mask));
    
    % Ratio in/ out
    ratio = in_int/(out_int+in_int);
    % Total
    tot_int = in_int;
    end
end

