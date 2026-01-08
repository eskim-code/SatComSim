function [primary_cell_sat_association, primary_cell_group, overhead_sats, overhead_sats_rel, overhead_psat_ecef, overhead_psat_lla, overhead_psat_ele]= ...
    MCT_association(psat_elevation, space_loc, num_tsample, ho_freq, total_cells_band, cell_priorities, center_cells,ecef_cell_locations, min_elevation)
   
    primary_cells = nonzeros(total_cells_band(:)); 
    num_primary_cells = length(primary_cells); % num_primary_cells_per_band * num_fband;
    [~,~,num_psats] = size(psat_elevation);
    ho_freq = 200; 


    [num_priority_groups, ~] = size(cell_priorities); 
    
    primary_cell_sat_association = zeros(num_tsample, num_priority_groups); %num_primary_cells); 

    overhead_sats = zeros(num_tsample, 50); 
    overhead_sats_rel = zeros(num_tsample,1); 
    primary_cell_group = zeros(num_tsample, num_priority_groups); 
    overhead_psat_ecef = zeros(num_tsample, 50, 3); 
    overhead_psat_lla = zeros(num_tsample, 50, 3); 
    overhead_psat_ele = zeros(num_tsample, num_priority_groups, 50); 
   

    for idx_t=1:num_tsample 
        tmp_psat_elevation = reshape(psat_elevation(idx_t, :, :), [], num_psats);
        active_sats_group = zeros(num_priority_groups, 50); 

        for idx_g=1:num_priority_groups
            cell_list_per_group = nonzeros(cell_priorities(idx_g, :)); 
            eli_sat_ids = find(all(tmp_psat_elevation(cell_list_per_group, :)>= min_elevation, 1)); 
   
            if ~isempty(eli_sat_ids)
                 active_sats_group(idx_g, 1:length(eli_sat_ids)) = eli_sat_ids;
            end
        end

        active_sats = unique(nonzeros(active_sats_group(:))); 
        num_active_sats = length(active_sats); 
        
        overhead_sats(idx_t,1:num_active_sats) = active_sats; 
        overhead_sats_rel(idx_t) = num_active_sats; 

       % Get satellite positions and elevations
        psat_ecef = squeeze(space_loc(:, idx_t, active_sats))';
        overhead_psat_ecef(idx_t, 1:num_active_sats, :) = psat_ecef;
        overhead_psat_lla(idx_t, 1:num_active_sats, :) = ecef2lla(psat_ecef);
        overhead_psat_ele (idx_t, :, 1:length(active_sats)) = psat_elevation(idx_t,center_cells, active_sats); 
        %overhead_psat_ele(idx_t, :, 1:num_active_sats) = psat_elevation(idx_t, :, active_sats);

        %end_tidx = min(idx_t+ho_freq-1, num_tsample); 
        %psat_elevation = psat_elevation(idx_t:end_idx, :, :);
        p_elevation = psat_elevation(idx_t:num_tsample, :, :);
        
        already_assigned_sats = nonzeros(primary_cell_sat_association(idx_t, :));
        if ~isempty(already_assigned_sats)
            p_elevation(1, :, already_assigned_sats) = -Inf;
        end
       
       
        % Assign satellites to cells
        for cell_group_idx = 1:num_priority_groups
            cell_list_per_group = nonzeros(cell_priorities(cell_group_idx, :)); 
            max_visible_sat= primary_cell_sat_association(idx_t, cell_group_idx);
            tmp_p_elevation = reshape(p_elevation(1, cell_list_per_group, :), [], num_psats); 
            sat_id = find(active_sats == max_visible_sat); 
            
            if ~isempty(sat_id)
                primary_cell_group(idx_t, cell_group_idx) = sat_id;
            else 
                eligible_sats = find(all(tmp_p_elevation(:, active_sats) >= min_elevation,1)); 

                if ~isempty(eligible_sats)
                    [row, col] = size(eligible_sats); 
                    if col==1 
                        col_with_all_ones = active_sats(eligible_sats); 
                        eligible_sats_elevation = p_elevation(:,cell_list_per_group, col_with_all_ones)>=min_elevation;
                        [index, time_duration] = find_shortest_consecutive_ones(eligible_sats_elevation);    
                        max_visible_sat = col_with_all_ones;
                        end_idx = min(idx_t+time_duration-1, num_tsample); 
                        primary_cell_sat_association(idx_t:end_idx, cell_group_idx)= max_visible_sat ; 
                        
                        p_elevation(1:time_duration,:,max_visible_sat) = -Inf;
                        primary_cell_group(idx_t,cell_group_idx) = find(active_sats == max_visible_sat) ; 
                    
                    elseif col>1
                        col_with_all_ones = active_sats(eligible_sats); 
                        
                        time_list = []; 
                        for i=1:length(col_with_all_ones)
                            eligible_sats_elevation = p_elevation(:,cell_list_per_group, col_with_all_ones(i))>=min_elevation;
                            [index, time_duration] = find_shortest_consecutive_ones(eligible_sats_elevation); 

                            time_list = [time_list, time_duration]; 
                        end
                        [duration, idx]= max(time_list);
                        max_visible_sat = col_with_all_ones(idx);
                        
                        end_idx = min(idx_t+duration-1, num_tsample); 
                        primary_cell_sat_association(idx_t:end_idx, cell_group_idx)= max_visible_sat ; 
                        p_elevation(1:duration,:,max_visible_sat) = -Inf;
                        primary_cell_group(idx_t,cell_group_idx) = find(active_sats == max_visible_sat) ; 
                    end
               
                else

                    %eligible_sats = find(all(psat_elevation(idx_t, cell_list_per_group, active_sats) >= min_elevation,2)); 
                    eligible_sats = find(all(tmp_psat_elevation(cell_list_per_group, active_sats) >= min_elevation,1)); 
                   
                    if ~isempty(eligible_sats)
                       [row, col] = size(eligible_sats); 
                        if col==1 
                            col_with_all_ones = active_sats(eligible_sats); 
                            eligible_sats_elevation = psat_elevation(idx_t:num_tsample,cell_list_per_group, col_with_all_ones)>=min_elevation;
                            [index, time_duration] = find_shortest_consecutive_ones(eligible_sats_elevation);    
                            max_visible_sat = col_with_all_ones;
                            end_idx = min(idx_t+time_duration-1, num_tsample); 
                            primary_cell_sat_association(idx_t:end_idx, cell_group_idx)= max_visible_sat ; 
                            %p_elevation(1:time_duration,:,max_visible_sat) = -Inf;
                            primary_cell_group(idx_t,cell_group_idx) = find(active_sats == max_visible_sat) ; 
                        
                        elseif col>1
                            col_with_all_ones = active_sats(eligible_sats); 
                            sat_list = []; 
                            time_list = []; 
                            for i=1:length(col_with_all_ones)
                                %eligible_sats_elevation = p_elevation(:,cell_list_per_group, col_with_all_ones(i))>=min_elevation;
                                eligible_sats_elevation = psat_elevation(idx_t:num_tsample,cell_list_per_group, col_with_all_ones(i))>=min_elevation;
                                [index, time_duration] = find_shortest_consecutive_ones(eligible_sats_elevation); 

                                time_list = [time_list, time_duration]; 
                            end
                           % [duration, idx]= max(time_list);
                            [duration, idx]= min(time_list);
                                
                            max_visible_sat = col_with_all_ones(idx);
                          

                            end_idx = min(idx_t+duration-1, num_tsample); 
                            tmp_psat_elevation(:, max_visible_sat) = - Inf; 
                            primary_cell_sat_association(idx_t:end_idx, cell_group_idx)= max_visible_sat ; 
                            primary_cell_group(idx_t,cell_group_idx) = find(active_sats == max_visible_sat) ; 
                          
                        end                    
                    else
            
                        assigned_indices = find(primary_cell_group(idx_t, :) ~= 0);
                   
                        if cell_group_idx == 1
                            % Find indices greater than cell_group_idx
                            idx_candidates = assigned_indices(assigned_indices > cell_group_idx);
                            if ~isempty(idx_candidates)
                                idx = idx_candidates(1); % Closest greater index
                            else
                                % No indices greater; choose the smallest assigned index
                                idx = min(assigned_indices);
                            end
                        else
                            idx_candidates = assigned_indices(assigned_indices < cell_group_idx);

                            if ~isempty(idx_candidates) 
                                idx = idx_candidates(end); %-2 * empty_idx1;
                                %empty_idx1 = empty_idx1 + 1; 
                            else 
                                %idx_candidates = assigned_indices(assigned_indices < cell_group_idx);                         
                                idx = max(assigned_indices); % - 2 * empty_idx2;
                                %empty_idx2 = empty_idx2 + 1; 
                            end
                        end
                   
                        if isempty(primary_cell_sat_association(idx_t, idx))    
                            idx = assigned_indices(end);
                            primary_cell_group(idx_t, cell_group_idx) = primary_cell_group(idx_t, idx);
                            primary_cell_sat_association(idx_t, cell_group_idx) = primary_cell_sat_association(idx_t, idx) ; % selected_idx;
                             % find(active_sats ==selected_idx); % Or NaN
                        else
                            primary_cell_sat_association(idx_t, cell_group_idx) = primary_cell_sat_association(idx_t, idx) ; % selected_idx;
                            primary_cell_group(idx_t, cell_group_idx) = primary_cell_group(idx_t, idx); % find(active_sats ==selected_idx); % Or NaN
                 
                        end

                    end
    
                end
            end
        end


    end

end

             