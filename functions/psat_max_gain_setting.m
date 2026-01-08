function primary_satellites = psat_max_gain_setting_r1(sys_params, sat, union_idx_primary, union_loc_primary  ) 

    num_primary_satellites = length(union_idx_primary); 
    for idx = 1:num_primary_satellites
        p = copy_object(sat);
        p.set_location(union_loc_primary(idx,:));
        p.active_num_beams = 0; 
        
       % add_loss = additional_primary_pathloss_in_dB(idx); 
    
      %  p.max_gain_dB = sys_params.max_antenna_gain_secondary_satellite_dB - add_loss; 
% %        p.id = union_idx_primary(idx); 
%     % SpaceX Constellation 
%     % Altitude Inclination #planes #sat/plane #satelltes
%     % 540        53.2       72      22          1584 
%     % 550        53         72      22          1584
%    %     % 560        97.6       4       43          172
%     % 560        97.6       6       58          348
%     % 570        70         36      20          720
    
        if  (union_idx_primary(idx) > 3688 && union_idx_primary(idx) < 4409) % altitude =570 km
            %p.transmit_power = sys_params.transmit_power_primary_satellite_watts + 0.4696; 
            p.transmit_power = sys_params.transmit_power_primary_satellite_dBm + 0.4696; % dBm
            p.altitude = 570e3;
        elseif (union_idx_primary(idx) >3168 &&  union_idx_primary(idx) < 3689 ) % altitude = 560 km 
             p.transmit_power = sys_params.transmit_power_primary_satellite_dBm + 0.3159; 
             p.altitude = 560e3;
        elseif (union_idx_primary(idx) > 1584 && union_idx_primary(idx) < 3169 ) % altitude = 550 km 
             p.transmit_power = sys_params.transmit_power_primary_satellite_dBm + 0.1594; 
             p.altitude = 550e3; 
        elseif (union_idx_primary(idx) > 4408 && union_idx_primary(idx) < 6901 )
             p.transmit_power = sys_params.transmit_power_primary_satellite_dBm -0.1594; 
             p.altitude = 530e3; 
            
        else % idx_primary(idx) <= 1584, altitude = 540 km 
            p.transmit_power = sys_params.transmit_power_primary_satellite_dBm;
            p.altitude = 540e3; 
        end
  
        primary_satellites{idx} = p;
    end
    
end
