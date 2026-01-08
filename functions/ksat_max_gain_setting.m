function secondary_satellites=ksat_max_gain_setting(sys_params,sat,union_idx_secondary,union_loc_secondary) 
    num_secondary_satellites = length(union_idx_secondary); 
    for idx = 1:num_secondary_satellites
        s = copy_object(sat);
        s.active_num_beams = 0; 
        %sat_id = union_idx_secondary(idx); 
        
        s.set_location(union_loc_secondary(idx,:));
                
        % max eirp at nadir -56.3576 @ 630km

        if(union_idx_secondary(idx) < 1157) % at 630km, reference max transmit power & max beam gain
            s.transmit_power = sys_params.transmit_power_secondary_satellite_dBm ; 
            s.altitude = 630e3; 
        elseif(union_idx_secondary(idx) > 2452) % at 590km,             
            s.transmit_power = sys_params.transmit_power_secondary_satellite_dBm - 0.5698; 
             s.altitude = 590e3; 
        else % at 610km 
           s.transmit_power = sys_params.transmit_power_secondary_satellite_dBm - 0.2802; 
            s.altitude = 610e3; 
        end
       
        secondary_satellites{idx} = s;
    end
end