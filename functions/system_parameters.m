% -------------------------------------------------------------------------
% System parameters.
% -------------------------------------------------------------------------

%  k_constant = -228.6 ; %dBW/K/Hz 
%  system_bandwidth = 500e6; 
%  system_bandwidth_dB = 10*log10(system_bandwidth);
%  carrier_frequency = 20e9; 
%  propagation_velocity = 3e8; 
%  carrier_wavelength = propagation_velocity / carrier_frequency;  

global sys_params; 
norm_tx_gain = 1; %1024; 
norm_rx_gain = 1; % 64; 
carrier_wavelength = sys_params.carrier_frequency; 
system_bandwidth = sys_params.system_bandwidth; 
system_bandwidth_dB = 10*log10(system_bandwidth);
carrier_frequency = sys_params.carrier_frequency; 
propagation_velocity = sys_params.propagation_velocity ; 
carrier_wavelength = sys_params.carrier_wavelength; 

k_constant = sys_params.k_constant ; %dBW/K/Hz 
gain_over_thermal_secondary_user = sys_params.gain_over_thermal_secondary_user; 


 sys_params.gain_over_thermal_secondary_user = 12.4; % 10.4 or 12.4 dB/K 
 %noise_power_secondary_user_per_Hz_dBm =   -174.7566; % gain_over_thermal_secondary_user + k_constant + 30 ; 
 noise_power_secondary_user_per_Hz_dBm = sys_params.noise_power_secondary_user_per_Hz_dBm; 

noise_power_secondary_user_dBm = sys_params.noise_power_secondary_user_dBm ; 
noise_power_secondary_user_watts= sys_params.noise_power_secondary_user_watts; 
max_antenna_gain_secondary_user_dB = sys_params.max_antenna_gain_secondary_user_dB;   % user rx beam gain ranges [29.5 ~ 45.2] dBi 
max_antenna_gain_secondary_user = sys_params.max_antenna_gain_secondary_user ;

%% sharing, secondary satellite (Kuiper satellite)
max_antenna_gain_secondary_satellite_dB = sys_params.max_antenna_gain_secondary_satellite_dB ; %dBi,  39dBi for 300km^2 and 37dBi for 500km^2 coverage, at altitude 630km
max_antenna_gain_secondary_satellite = sys_params.max_antenna_gain_secondary_satellite; 

EIRP_secondary_satellite_dBW_Hz = sys_params.EIRP_secondary_satellite_dBW_Hz ; 
EIRP_secondary_satellite_dBm_Hz = sys_params.EIRP_secondary_satellite_dBm_Hz ; 
EIRP_secondary_satellite_dBm = sys_params.EIRP_secondary_satellite_dBm ; 
transmit_power_secondary_satellite_dBm = sys_params.transmit_power_secondary_satellite_dBm; 
transmit_power_secondary_satellite_watts = sys_params.transmit_power_secondary_satellite_watts ; 


%% protected, primary user
% same parameters as sharing user parameters for now
gain_over_thermal_primary_user = sys_params.gain_over_thermal_primary_user ; % 10.4 or 12.4 dB/K 

%noise_power_primary_user_dBm = -94 + 10;
noise_power_primary_user_per_Hz_dBm = sys_params.noise_power_primary_user_per_Hz_dBm ; 
%noise_power_primary_user_per_Hz_dBm =  -174.7566; %gain_over_thermal_primary_user + k_constant + 30 ; 
noise_power_primary_user_dBm = sys_params.noise_power_primary_user_dBm;
noise_power_primary_user_watts = sys_params.noise_power_primary_user_watts ;
max_antenna_gain_primary_user_dB = sys_params.max_antenna_gain_primary_user_dB ;
max_antenna_gain_primary_user = sys_params.max_antenna_gain_primary_user; 

%% protected, primary satellite
max_antenna_gain_primary_satellite_dB = sys_params.max_antenna_gain_primary_satellite_dB ;
max_antenna_gain_primary_satellite = sys_params.max_antenna_gain_primary_satellite ;
EIRP_primary_satellite_dBW_Hz = sys_params.EIRP_primary_satellite_dBW_Hz ; 
EIRP_primary_satellite_dBm_Hz = sys_params.EIRP_primary_satellite_dBm_Hz ; 
EIRP_primary_satellite_dBm = sys_params.EIRP_primary_satellite_dBm ; 
transmit_power_primary_satellite_dBm = sys_params.transmit_power_primary_satellite_dBm; 
transmit_power_primary_satellite_watts = sys_params.transmit_power_primary_satellite_watts ; 



