function [primary_inr, secondary_inr, secondary_snr, sats_to_consider] = est_primary_system_rx_power(sys_params,...
    unique_psat, unique_ksat, primary_satellites,secondary_satellites,...
    primary_users, secondary_users, primary_sat_association, p_ecef_cell_locations, ...
    s_ecef_cell_locations,cells_per_freq_band,cell_priorities, num_active_beams)


    num_psat_in_view = length(unique_psat); 
    num_ksat_in_view = length(unique_ksat);

    [num_primary_users,~] = size(p_ecef_cell_locations);
    [num_cell_groups,~] = size(cell_priorities); 
    num_active_beam_ratio = num_active_beams/42; 


    % primary_inr = zeros(num_primary_users,num_ksat_in_view, num_cell_groups); %
    % secondary_inr=  zeros(num_primary_users,num_ksat_in_view, num_cell_groups);
    % secondary_snr=  zeros(num_primary_users,num_ksat_in_view, num_cell_groups);

    primary_inr = zeros(num_primary_users,50, num_cell_groups); %
    secondary_inr=  zeros(num_primary_users,50, num_cell_groups);
    secondary_snr=  zeros(num_primary_users,50, num_cell_groups);
    
    
    % num_inband_cells = length(cells_per_freq_band); 

    sats_to_consider = [];
    primary_txp= zeros(num_cell_groups, num_active_beams);  
    primary_asso_cells= zeros(num_cell_groups, num_active_beams);
    primary_eligile_beam_ids = zeros(num_cell_groups, num_active_beams); 
    psat_ids = zeros(num_cell_groups, 1);  
    
    % cell_ids_collect = nonzeros(cell_priorities(1:7,:)); 
    % indices = ismember( cells_per_freq_band, cell_ids_collect); 
    % inband_data_collect_cells = cells_per_freq_band(indices); % inband_active_cells for secondary system
    % num_inband_data_collect_cells = length(inband_data_collect_cells);


    % primary serving satellites transmission
    for idx_g = 1:num_cell_groups     
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
             end
        end
        num_asso_cells = length(asso_cells);
        primary_txp(idx_g, 1:num_asso_cells) = txp; 
        primary_asso_cells(idx_g, 1:num_asso_cells) = asso_cells; 
        primary_eligile_beam_ids(idx_g, 1:num_asso_cells) = eligible_beam_ids; 
        psat_ids(idx_g) = psat_id; 
    end
    primary_inband_active_cells = nonzeros(primary_asso_cells); 
    
    % secondary serving satellites transmission
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

        secondary_inband_cells(idx_g, 1:num_active)= active_inband_group_cells;
    end
    secondary_inband_active_cells = nonzeros(secondary_inband_cells); 
    
    num_active_inband_cells = min(length(primary_inband_active_cells), length(secondary_inband_active_cells));
     

    for idx_s=1:num_ksat_in_view
        %ksat_idx = unique_ksat(idx_s); 
        s = secondary_satellites{idx_s};
        beam_id = 1; 

        for idx_g = 1: num_cell_groups

            active_inband_group_cells = nonzeros(secondary_inband_cells(idx_g, :)); 
            num_active_inband_group_cells = length(active_inband_group_cells);
    
            sgroup_cell_loc = s_ecef_cell_locations(active_inband_group_cells, :); 
            elevation_group = return_elevation_sats(s.location, sgroup_cell_loc, sgroup_cell_loc, [0,0,0]); %(28,1)
            
            if all(elevation_group>=35)
                sats_to_consider = [sats_to_consider idx_s];
            end
            
            if all(elevation_group >= 35)
                tmp_primary_inr = zeros(num_primary_users,1); 
                tmp_secondary_inr = zeros(num_primary_users,1); 
    
                % primary satellite transmission
                p_txp = nonzeros(primary_txp(idx_g, :)); 
                p_asso_cells = nonzeros(primary_asso_cells(idx_g, :)); 
                
                p_beam_ids = nonzeros(primary_eligile_beam_ids(idx_g, :));
                psat_id = psat_ids(idx_g); 
                p = primary_satellites{psat_id};
               
                for idx_c=1:num_active_inband_group_cells % account for actual transmission 
                    % primary system, primary satellite transmission
                    p_idx_c = p_asso_cells(idx_c);
                    pbeam_idx = p_beam_ids(idx_c); 
                    ptxp = p_txp(idx_c); 
                    
                    
                    % secondary system, secondary satellite steers beam
                    % toward cell_id1. 
%                     new_idx_c = active_inband_group_indices(idx_c);
%                     cell_id1 = inband_group_cell_ids(new_idx_c); % secondary user location 
                    s_cell_id1 = active_inband_group_cells(idx_c);   
                    su = secondary_users{s_cell_id1}; 
                    su.location = s_ecef_cell_locations(s_cell_id1,:);
                    
                    s = steer_sat_beam_cell(s, beam_id, su.location); % to determine secondary satellite tx. power                     
                    elevation = get_elevation_angles_locs(s.location, su.location); 
                    adj_dB = satellite_transmit_power_adjustment_ele(s.altitude, elevation); 
                    tmp_tx_pwr = s.transmit_power + adj_dB; 
                    
           
                    for idx_u=1: num_active_inband_cells % num_inband_data_collect_cells %num_inband_cells % actual inr calculation 
                        p_cell_id2 = primary_inband_active_cells(idx_u);
                        s_cell_id2 = secondary_inband_active_cells(idx_u);
                       % cell_id2 = cells_per_freq_band(idx_u);
                        pu = primary_users{p_cell_id2}; % primary users already steer their beams to their serving satellites
                        %pu = steer_u_beam(su, p);

                        [~,~, ~, tmp] = get_beamformed_path_loss(s, 1, pu);
                        tmp_primary_inr(p_cell_id2) = tmp_primary_inr(p_cell_id2) +  (tmp * ...
                           dBm2watts(tmp_tx_pwr) /sys_params.noise_power_secondary_user_watts); 
                       
                        su = secondary_users{s_cell_id2}; 
                        su = steer_u_beam(su,s); 
                       [~,~, ~, tmp] = get_beamformed_path_loss(p, pbeam_idx, su);% primary satellite steers beam[pbeam_idx] to 
                        tmp_secondary_inr(s_cell_id2) = tmp_secondary_inr(s_cell_id2) +  (tmp * ...
                           dBm2watts(ptxp) /sys_params.noise_power_secondary_user_watts); 
    
                        if s_cell_id1==s_cell_id2
                             [~,~, ~, tmp] = get_beamformed_path_loss(s, 1, su);
                             secondary_snr(s_cell_id1, idx_s, idx_g) = (tmp * ...
                           dBm2watts(tmp_tx_pwr) /sys_params.noise_power_secondary_user_watts); 
                        end
                  
                    end
                end

                %primary_inr(cells_per_freq_band, idx_s, idx_g) = tmp_primary_inr(cells_per_freq_band); 
                %secondary_inr(cells_per_freq_band, idx_s, idx_g) = tmp_secondary_inr(cells_per_freq_band); 
                primary_inr(primary_inband_active_cells, idx_s, idx_g) = tmp_primary_inr(primary_inband_active_cells); 
                secondary_inr(secondary_inband_active_cells, idx_s, idx_g) = tmp_secondary_inr(secondary_inband_active_cells); 

            end

        end
    end
end


