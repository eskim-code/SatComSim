
function [primary_cell_sat_association, primary_cell_group, overhead_sats, overhead_sats_rel, overhead_psat_ecef, overhead_psat_lla, overhead_psat_ele]...
    = HE_association(psat_elevation, space_loc, num_tsample, ho_freq,...
    total_cells_band, cell_priorities, center_cells, min_elevation) % primary_cells, num_primary_cells_per_band)
       

%% per cell group 
    primary_cells = nonzeros(total_cells_band(:));   
    [num_priority_groups, ~] = size(cell_priorities);     
    primary_cell_sat_association = zeros(num_tsample, num_priority_groups) ; %num_primary_cells_per_band);
    [~,~,num_psats] = size(space_loc);

    overhead_sats = zeros(num_tsample, 50); 
    overhead_sats_rel = zeros(num_tsample,1); 
    primary_cell_group = zeros(num_tsample, num_priority_groups); 
    overhead_psat_ecef = zeros(num_tsample, 50, 3); 
    overhead_psat_lla = zeros(num_tsample, 50, 3); 
    overhead_psat_ele = zeros(num_tsample,num_priority_groups, 50); 

    for idx_t=1:num_tsample
        active_sats = []; 
        tmp_psat_elevation = reshape(psat_elevation(idx_t, :, :), [], num_psats);

        for idx_g=1:num_priority_groups
            cell_list_per_group = nonzeros(cell_priorities(idx_g, :)); 
            %eli_sat_ids = find(all(tmp_psat_elevation(cell_list_per_group, :)>= min_elevation, 1));
            eli_sat_ids = find(any(tmp_psat_elevation(cell_list_per_group, :)>= min_elevation, 1));
            if ~isempty(eli_sat_ids)
                 active_sats = [active_sats eli_sat_ids];
            end
           
        end

        active_sats = unique(active_sats); 
        num_active_sats = length(active_sats); 

        if mod(idx_t, ho_freq) ==1 || ho_freq ==1
            end_idx = min(idx_t+ho_freq-1, num_tsample); 
            p_elevation = psat_elevation(idx_t:end_idx, :, :);
        end
        
        overhead_sats(idx_t,1:num_active_sats) = active_sats; 
        overhead_sats_rel(idx_t) = num_active_sats; 

        psat_ecef = squeeze(space_loc(:, idx_t,active_sats))';
        overhead_psat_ecef(idx_t, 1:num_active_sats, :) =psat_ecef; % reshape(psat_ecef, [], 3);
        overhead_psat_lla(idx_t,1:num_active_sats,:) = ecef2lla(psat_ecef); 
        overhead_psat_ele (idx_t, :, 1:num_active_sats) = psat_elevation(idx_t,center_cells, active_sats); 

        for idx_priority = 1: num_priority_groups
            cell_list_per_group = nonzeros(cell_priorities(idx_priority, :)); 
            max_visible_sat = primary_cell_sat_association(idx_t, idx_priority); 
            sat_id = find(active_sats == max_visible_sat); 
            tmp_p_elevation = reshape(p_elevation(1, cell_list_per_group, :), [], num_psats); 
            
            if ~isempty(sat_id)
                primary_cell_group(idx_t, idx_priority) = sat_id;
                continue; 
            end

            if mod(idx_t, ho_freq) ==1 || ho_freq ==1
                eligible_sats = find(all(tmp_p_elevation(:, active_sats) >= min_elevation,1)); 


                if ~isempty(eligible_sats)
                    [row, col] = size(eligible_sats);
                    col_with_all_ones = active_sats(eligible_sats);
                      if col==1           

                           sat_idx_in_list = col_with_all_ones; %(max_elevation_sat);   
                           primary_cell_sat_association(idx_t:end_idx, idx_priority)= sat_idx_in_list ; % unique_psat(sat_idx_in_list);                                     
                           p_elevation(:, :, sat_idx_in_list) = - Inf;
                           primary_cell_group(idx_t,idx_priority) = find(active_sats == sat_idx_in_list) ; 
                           

                       else 
                            eligible_sat_elevation = squeeze(p_elevation(1, center_cells(idx_priority), col_with_all_ones));                
                            [~,max_elevation_sat] = max(eligible_sat_elevation);
                            sat_idx_in_list = col_with_all_ones(max_elevation_sat);
                            primary_cell_sat_association(idx_t:end_idx, idx_priority)= sat_idx_in_list; % unique_psat(sat_idx_in_list);             
                            primary_cell_group(idx_t, idx_priority) = find(active_sats == sat_idx_in_list);
                            p_elevation(:, :, sat_idx_in_list) = - Inf; 
    
                       end             
                else
                     tmp_psat_elevation = reshape(psat_elevation(idx_t, cell_list_per_group, : ),[], num_psats ); 
                    
                     eli_sat_ids = find(all(tmp_psat_elevation>= min_elevation, 1)); 
                     
                     
                     if ~isempty(eli_sat_ids)
                         eli_sat_elevation = squeeze(psat_elevation(idx_t, center_cells(idx_priority), eli_sat_ids));
                        
                         [~,max_elevation_sat] = max(eli_sat_elevation);
                         sat_idx_in_list = eli_sat_ids(max_elevation_sat);
                         primary_cell_sat_association(idx_t:end_idx, idx_priority)= sat_idx_in_list; % unique_psat(sat_idx_in_list);             
                         primary_cell_group(idx_t, idx_priority) = find(active_sats == sat_idx_in_list);

                     else
                        assigned_indices = find(primary_cell_sat_association(idx_t, :) ~= 0);                 
                        if idx_priority == 1
                            % Find indices greater than cell_group_idx
                            idx_candidates = assigned_indices(assigned_indices > idx_priority);
                            if ~isempty(idx_candidates)
                                idx = idx_candidates(1); % Closest greater index
                            else
                                % No indices greater; choose the smallest assigned index
                                idx = min(assigned_indices);
                            end
                        else

                            idx_candidates = assigned_indices(assigned_indices < idx_priority);

                            if ~isempty(idx_candidates) 
                                idx = idx_candidates(end); %-2 * empty_idx1;
                            else 
                                idx = max(assigned_indices); % - 2 * empty_idx2;
                            end
                        end

                        if isempty(primary_cell_sat_association(idx_t, idx)) 
                            idx = assigned_indices(end);
                            primary_cell_sat_association(idx_t, idx_priority) = primary_cell_sat_association(idx_t, idx);
                            primary_cell_group(idx_t, idx_priority) = primary_cell_group(idx_t, idx);
                        else
                            primary_cell_sat_association(idx_t:end_idx, idx_priority) = primary_cell_sat_association(idx_t, idx) ; % selected_idx;
                            primary_cell_group(idx_t, idx_priority) = primary_cell_group(idx_t, idx); % find(active_sats ==selected_idx); % Or NaN
                     
                        end
                     end 

                end
            end
        end
    end
end
      

  
