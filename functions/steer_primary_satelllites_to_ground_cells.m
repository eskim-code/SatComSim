function [primary_satellites, primary_users] =...
    steer_primary_satelllites_to_ground_cells(primary_sat_loc, primary_satellites,...
    primary_users, primary_cell_sat_association, ecef_cell_locations, cell_priorities, unique_psat)%, primary_cells_per_fband)

    [num_cell_groups, ~] = size(cell_priorities); 
             
    for idx=1: num_cell_groups % 
        cell_list = nonzeros(cell_priorities(idx,:));
        asso_sat_id = primary_cell_sat_association(idx);

        pr_ssat_idx = find(unique_psat == asso_sat_id);
        
%         if isempty(pr_ssat_idx)
%             print("empty")
%         end
        
        p = primary_satellites{pr_ssat_idx}; 
        
        num_beam_start = p.active_num_beams; 
        p.active_num_beams = p.active_num_beams + length(cell_list); 

        pcell_loc = ecef_cell_locations(cell_list,:);

        elevation = return_elevation_sats(p.location, pcell_loc, pcell_loc, [0,0,0]); 
        
       adj_dB = satellite_transmit_power_adjustment_ele(p.altitude, elevation); %(pr_ssat_idx)); 
       
       for idx_b = 1:length(cell_list)
            cell_id = cell_list(idx_b); 
            pu = primary_users{cell_id}; 
          
            beam_id = num_beam_start + idx_b; 
            p.beam{beam_id}.transmit_power = p.transmit_power + adj_dB(idx_b) ; 
            p = steer_sat_beam_cell(p, beam_id, ecef_cell_locations(cell_id, :));
           % p = steer_sat_beam_cell(p,beam_id, pcell_loc);
            p.beam{beam_id}.serving_cell = cell_list(idx_b); % idx_cell; 
            pu = steer_u_beam(pu, p); 
            primary_users{cell_id} = pu; 
            primary_satellites{pr_ssat_idx} = p; 
       end
    end

end