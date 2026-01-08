function adj_dB = satellite_transmit_power_adjustment_ele(altitude, elevation)
    
    % compute starlink max eirp at altitude 540e3
    radius_earth = 6371e3; 
    
    ele = deg2rad(elevation);
    distance_per_ele = sqrt(radius_earth^2 * sin(ele).*sin(ele) + altitude^2 + 2*altitude * radius_earth) - radius_earth *sin(ele); 
    adj_dB = pow2dB(distance_per_ele.^2) - pow2dB(altitude.^2); 

end