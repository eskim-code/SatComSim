function sat = steer_sat_beam_cell(sat,beam_id, cell)
    s_loc = sat.location; 
    %u_loc = usr.location;
    % mechanically steer each arry so that broadside is towrd Earth
    [dist, th, ph] = get_relative_position(s_loc, cell); 
    sat.beam{beam_id}.array.steer(th, ph, true); 

    %sat.beam{beam_id}.transmit_power = set_max_eirp_per_dist(sat, dist); 
    
    [~, th, ph] = get_relative_position(s_loc, cell); 
    sat.beam{beam_id}.set_steering_direction(th, ph);
end

