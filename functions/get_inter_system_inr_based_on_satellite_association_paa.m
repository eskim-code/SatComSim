function [primary_snr, secondary_snr, primary_intra_inr, primary_inter_inr, ...
    secondary_intra_inr, secondary_inter_inr] =...
    get_inter_system_inr_based_on_satellite_association_paa(sys_params, primary_satellites, secondary_satellites, ...
    primary_users, secondary_users,unique_psat, unique_ksat, primary_sat_association,secondary_sat_association, ...
    p_ecef_cell_locations, cells_per_freq_band, cell_priorities, num_active_beams)
 
    cells_per_freq_band = nonzeros(cells_per_freq_band);
    [num_primary_cells,~] = size(p_ecef_cell_locations);
    num_active_beam_ratio = num_active_beams/42; 

 

    [num_cell_groups,~] = size(cell_priorities); 
    primary_snr = zeros(num_primary_cells, 1); %
    secondary_snr = zeros(num_primary_cells, 1); %
    primary_intra_inr = zeros(num_primary_cells,1); %, n
    primary_inter_inr = zeros(num_primary_cells,1); %, n
    secondary_intra_inr = zeros(num_primary_cells,1); %, n
    secondary_inter_inr = zeros(num_primary_cells,1); %, n

    primary_txp= zeros(num_cell_groups, num_active_beams);  
    primary_asso_cells= zeros(num_cell_groups, num_active_beams);
    primary_eligile_beam_ids = zeros(num_cell_groups, num_active_beams); 
    psat_ids = zeros(num_cell_groups, 1);  

    secondary_txp= zeros(num_cell_groups, num_active_beams);  
    secondary_asso_cells= zeros(num_cell_groups, num_active_beams);
    secondary_eligile_beam_ids = zeros(num_cell_groups, num_active_beams); 
    ksat_ids = zeros(num_cell_groups, 1);  

    for idx_g =1:num_cell_groups
        cell_ids = nonzeros(cell_priorities(idx_g,:)); 
        indices = ismember( cells_per_freq_band, cell_ids); 
        inband_group_cell_ids = cells_per_freq_band(indices); 
        num_inband_group_cells = length(inband_group_cell_ids);

        num_active_beams_per_group = floor(num_active_beam_ratio * num_inband_group_cells); 

        active_inband_group_indices=...
            randperm(num_inband_group_cells, min(num_active_beams_per_group,num_inband_group_cells));
        active_inband_group_cells = inband_group_cell_ids(active_inband_group_indices); 

        psat_idx = primary_sat_association(idx_g);
        psat_id = find(unique_psat == psat_idx);
        p = primary_satellites{psat_id};  
        num_beams = p.active_num_beams; 

        asso_cells = []; 
        txp = []; 
        eligible_beam_ids=[];

        for idx_beam=1:num_beams
             associated_cell = p.beam{idx_beam}.serving_cell;
             if ismember(associated_cell, active_inband_group_cells) % inband_group_cell_ids)
                 asso_cells = [asso_cells, associated_cell];
                 txp = [txp, p.beam{idx_beam}.transmit_power]; 
                 eligible_beam_ids =[eligible_beam_ids, idx_beam]; 
                 pu = primary_users{associated_cell}; 
                 [~,~, ~, tmp] = get_beamformed_path_loss(p, idx_beam, pu);
                 primary_snr(associated_cell) = (tmp * ...
                    dBm2watts(p.beam{idx_beam}.transmit_power) /sys_params.noise_power_secondary_user_watts); 
             end
        end
        num_asso_cells = length(asso_cells);
        primary_txp(idx_g, 1:num_asso_cells) = txp; 
        primary_asso_cells(idx_g, 1:num_asso_cells) = asso_cells; 
        primary_eligile_beam_ids(idx_g, 1:num_asso_cells) = eligible_beam_ids; 
        psat_ids(idx_g) = psat_id; 
    end

    primary_inband_active_cells = nonzeros(primary_asso_cells); 

    secondary_inband_cells = zeros(num_cell_groups, num_active_beams);
    for idx_g = 1:num_cell_groups     
        cell_ids = nonzeros(cell_priorities(idx_g,:)); 
        indices = ismember( cells_per_freq_band, cell_ids); 
        inband_group_cell_ids = cells_per_freq_band(indices); 
        num_inband_group_cells = length(inband_group_cell_ids);

        num_active_beams_per_group = floor(num_active_beam_ratio * num_inband_group_cells); 

        active_inband_group_indices=...
            randperm(num_inband_group_cells, min(num_active_beams_per_group,num_inband_group_cells));
        active_inband_group_cells = inband_group_cell_ids(active_inband_group_indices); 
        num_active = length(active_inband_group_cells);


        asso_kcells = []; 
        txp_k = []; 
        eligible_kbeam_ids=[];

        ksat_idx = secondary_sat_association(idx_g);
        ksat_id = find(unique_ksat == ksat_idx);
        s = secondary_satellites{ksat_id};  
        num_kbeams = s.active_num_beams; 

        for idx_beam=1:num_kbeams
             associated_cell = s.beam{idx_beam}.serving_cell;
             if ismember(associated_cell, active_inband_group_cells) % inband_group_cell_ids)
                 asso_kcells = [asso_kcells, associated_cell];
                 txp_k = [txp_k, s.beam{idx_beam}.transmit_power]; 
                 eligible_kbeam_ids =[eligible_kbeam_ids, idx_beam]; 
                 su = secondary_users{associated_cell}; 
                 [~,~, ~, tmp] = get_beamformed_path_loss(s, idx_beam, su);
                 secondary_snr(associated_cell) = (tmp * ...
                    dBm2watts(s.beam{idx_beam}.transmit_power) /sys_params.noise_power_secondary_user_watts); 
             end
        end
        num_asso_kcells = length(asso_kcells);
        secondary_txp(idx_g, 1:num_asso_kcells) = txp_k; 
        secondary_asso_cells(idx_g, 1:num_asso_kcells) = asso_kcells; 
        secondary_eligile_beam_ids(idx_g, 1:num_asso_kcells) = eligible_kbeam_ids; 
        ksat_ids(idx_g) = ksat_id; 
        secondary_inband_cells(idx_g, 1:num_active)= active_inband_group_cells;
    end
    secondary_inband_active_cells = nonzeros(secondary_inband_cells); 
    num_active_inband_cells = min(length(primary_inband_active_cells), length(secondary_inband_active_cells));
   

    for idx_g =1:num_cell_groups
        psat_id= psat_ids(idx_g); 
        ksat_id= ksat_ids(idx_g); 
        
        p = primary_satellites{psat_id}; 
        s = secondary_satellites{ksat_id}; 

        secondary_asso_cells_group = nonzeros(secondary_asso_cells(idx_g,:));
        primary_asso_cells_group = nonzeros(primary_asso_cells(idx_g,:)); 
        eligible_beam_ids_group = nonzeros(primary_eligile_beam_ids(idx_g, :));
        eligible_kbeam_ids_group = nonzeros(secondary_eligile_beam_ids(idx_g, :));   
        txp = nonzeros(primary_txp(idx_g, :)); 
        txp_k = nonzeros(secondary_txp(idx_g, :));

        num_active_inband_group_cells = length(secondary_asso_cells_group);

        for idx_c=1:num_active_inband_group_cells % num_inband_group_cells
           % primary satellite beam idx / transmit_power
           %new_idx_c = active_inband_group_indices(idx_c);
           p_cell_idx1 = primary_asso_cells_group(idx_c); 
           pbeam_idx = eligible_beam_ids_group(idx_c);
           pbeam_txp = txp(idx_c); 

           k_cell_idx1 = secondary_asso_cells_group(idx_c);
           kbeam_idx = eligible_kbeam_ids_group(idx_c);
           kbeam_txp = txp_k(idx_c); 

           %cell_id1 =active_inband_group_cells(idx_c); %  inband_group_cell_ids(new_idx_c);          
 
           for idx_u=1:num_active_inband_cells % length(cells_per_freq_band)
              % cell_id2 = cells_per_freq_band(idx_u);
               k_cell_idx2 = secondary_inband_active_cells(idx_u);
               p_cell_idx2 = primary_inband_active_cells(idx_u);   
               % interference from a primary satellite to secondary user
               su = secondary_users{k_cell_idx2}; 
               pu = primary_users{p_cell_idx2}; 

               [~,~, ~, tmp] = get_beamformed_path_loss(p, pbeam_idx, su);
               tmp_inr = (tmp * dBm2watts(pbeam_txp) /sys_params.noise_power_secondary_user_watts);
               secondary_inter_inr(k_cell_idx2) = secondary_inter_inr(k_cell_idx2) + tmp_inr;
               % interference from a secondary satellite to a primary user 
               
               [~,~, ~, tmp] = get_beamformed_path_loss(s, kbeam_idx, pu);
               tmp_inr = (tmp * dBm2watts(kbeam_txp) /sys_params.noise_power_secondary_user_watts);
               primary_inter_inr(p_cell_idx2) = primary_inter_inr(p_cell_idx2) + tmp_inr;

               if p_cell_idx1 ~= p_cell_idx2         
                   [~,~, ~, tmp] = get_beamformed_path_loss(p, pbeam_idx, pu);
                   tmp_inr = (tmp * dBm2watts(pbeam_txp) /sys_params.noise_power_secondary_user_watts);                 
                   primary_intra_inr(p_cell_idx2) = primary_intra_inr(p_cell_idx2) + tmp_inr;  
               elseif k_cell_idx1 ~= k_cell_idx2

                   [~,~, ~, tmp] = get_beamformed_path_loss(s, kbeam_idx, su);
                   tmp_inr = (tmp * dBm2watts(kbeam_txp) /sys_params.noise_power_secondary_user_watts);                 
                   secondary_intra_inr(k_cell_idx2) = primary_intra_inr(k_cell_idx2) + tmp_inr;  
               end
            end
        end
    end

end

