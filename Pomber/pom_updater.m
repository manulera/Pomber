function [ h ] = pom_updater( h )
    % Update the handles such that they are up to date with the last
    % version of Pomber
    h = update_frame_list( h );
    if ~isfield(h,'all_pos_names')
        h.all_pos_names = pom_update_pos_names(h);
    end
    % Addition of the drift
    if ~isfield(h,'drift')
        h.drift = [];
        h.drift_applied = false;
    end
    
    return
    if ~isfield(h,'version')
        h.version = '1.0';
    end
    if ~strcmp(h.version,'1.2')
        if numel(h.cells)
            % Old version didn't have a merge channel in the closeup, it
            % was updated
            for i = 1:numel(h.cells)
                %% Deal with the merge channel
                
                if numel(h.cells{i}.video)<4
                    
                    chan2merge = find(h.an_type>2);
                    if numel(chan2merge)==2
                        c1 = chan2merge(1);
                        c2 = chan2merge(2);
                        h.cells{i}.video{4} = make_merge(h.cells{i}.video{c1},h.cells{i}.video{c2},h.im_info.contrast(c1,:),h.im_info.contrast(c2,:));
                    elseif numel(chan2merge)>2
                        warndlg('More than two channels are set to do the merging')
                    end
                end
                
            end
        end
        if isfield(h,'resolution')
            h.im_info.resolution = h.resolution;
            h.im_info.contrast = h.contrast;
            h.im_info.im_bg = h.im_bg;
            h = rmfield(h,'resolution');
            h = rmfield(h,'contrast');
            h = rmfield(h,'im_bg');
        end
        if ~isfield(h,'squares')
            h.squares = {};
        end
        h = pom_again(h);
        h.version =('1.1');
    end
end

