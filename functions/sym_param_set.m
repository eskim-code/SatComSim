%function [output_file_name] = sym_param_set(sym_param_file, result)

%global sys_params; 

% 
% psat.array.num_antennas; 
% susr.array.num_antennas;

 sys_params.k_constant = -228.6 ; %dBW/K/Hz 
 T0 = 290; %K
 Ta = 150 ; %K
 Nf = 1.2; % (dB)
 atmospehric_loss = 0.5; 
 sys_params.system_bandwidth = 100e6; 
 sys_params.system_bandwidth_dB = 10*log10(sys_params.system_bandwidth);
 sys_params.carrier_frequency = 20e9; 
 sys_params.propagation_velocity = 3e8; 
 sys_params.carrier_wavelength = sys_params.propagation_velocity / sys_params.carrier_frequency;  
% 

 sys_params.gain_over_thermal_secondary_user = 18.5; % 12.4; % 10.4 or 12.4 dB/K 
 sys_params.noise_power_secondary_user_per_Hz_dBm = -174.7566 + Nf; 
% sys_params.noise_power_secondary_user_per_Hz_dBm =  Nf + 10*log10(T0 +(Ta-T0)*10^(-0.1 *Nf)) + sys_params.k_constant + 30;  
 %-174.7566 +1.2; % gain_over_thermal_secondary_user + k_constant + 30 ; 
 %sys_params.noise_power_secondary_user_per_Hz_dBm =  sys_params.gain_over_thermal_secondary_user + sys_params.k_constant + 30 ; 

sys_params.noise_power_secondary_user_dBm = sys_params.noise_power_secondary_user_per_Hz_dBm + sys_params.system_bandwidth_dB; 
sys_params.noise_power_secondary_user_watts = dBm2watts(sys_params.noise_power_secondary_user_dBm);

if sys_params.mask
    sys_params.max_antenna_gain_secondary_user_dB = 30; % 32.5;  % user rx beam gain ranges [29.5 ~ 45.2] dBi 
    sys_params.max_antenna_gain_primary_user_dB =  30;
    sys_params.max_antenna_gain_secondary_satellite_dB =  34.5; % pow2db(ksat.beam{1}.array.num_antennas); %34.5; %34.5;  % 39; %  39dBi for 300km^2 and 37dBi for 500km^2 coverage, at altitude 630km
    sys_params.max_antenna_gain_primary_satellite_dB =  34.5; % pow2db(psat.beam{1}.array.num_antennas); % 34.5; % 34.5;

else
    sys_params.max_antenna_gain_secondary_user_dB = pow2db(susr.beam.array.num_antennas); % 32.5;  % user rx beam gain ranges [29.5 ~ 45.2] dBi 
    sys_params.max_antenna_gain_primary_user_dB =  pow2db(pusr.beam.array.num_antennas); % 32.5;
    sys_params.max_antenna_gain_primary_satellite_dB = pow2db(psat.beam{1}.array.num_antennas); % 34.5; % 34.5;
    sys_params.max_antenna_gain_secondary_satellite_dB = pow2db(ksat.beam{1}.array.num_antennas); %34.5; %34.5;  % 39; %  39dBi for 300km^2 and 37dBi for 500km^2 coverage, at altitude 630km

end

sys_params.max_antenna_gain_secondary_user = dB2pow(sys_params.max_antenna_gain_secondary_user_dB);

sys_params.noise_power_primary_user_dBm = sys_params.noise_power_secondary_user_dBm; %sys_params.noise_power_secondary_user_per_Hz_dBm + sys_params.system_bandwidth_dB; 
sys_params.noise_power_primary_user_watts = dBm2watts(sys_params.noise_power_secondary_user_dBm);
sys_params.max_antenna_gain_measurement_user_dB =  sys_params.max_antenna_gain_secondary_user_dB; %pow2db(susr.beam.array.num_antennas); % 32.5;  % user rx beam gain ranges [29.5 ~ 45.2] dBi 
sys_params.max_antenna_gain_measurement_user = dB2pow(sys_params.max_antenna_gain_measurement_user_dB);

%% sharing, secondary satellite (Kuiper satellite)
sys_params.max_antenna_gain_secondary_satellite = dB2pow(sys_params.max_antenna_gain_secondary_satellite_dB);
sys_params.EIRP_secondary_satellite_dBW_Hz = -53.5; % -53.3; %  -56.9273 would be the right choice from my calculation, but rely on -53.3 for now. ; %-53.3;
sys_params.EIRP_secondary_satellite_dBm_Hz = sys_params.EIRP_secondary_satellite_dBW_Hz + 30 ; 
sys_params.EIRP_secondary_satellite_dBm = sys_params.EIRP_secondary_satellite_dBm_Hz + 10*log10(sys_params.system_bandwidth);

sys_params.transmit_power_secondary_satellite_dBm = sys_params.EIRP_secondary_satellite_dBm - sys_params.max_antenna_gain_secondary_satellite_dB;
sys_params.transmit_power_secondary_satellite_watts = dBm2watts(sys_params.transmit_power_secondary_satellite_dBm);


%% protected, primary user
% same parameters as sharing user parameters for now
sys_params.gain_over_thermal_primary_user = 18.5; % 12.4 ; % 10.4 or 12.4 dB/K 

%noise_power_primary_user_dBm = -94 + 10;
% sys_params.noise_power_primary_user_per_Hz_dBm =  sys_params.gain_over_thermal_primary_user + sys_params.k_constant + 30 ; 
sys_params.noise_power_primary_user_per_Hz_dBm =  -174.7566 + Nf; %gain_over_thermal_primary_user + k_constant + 30 ; 
sys_params.noise_power_primary_user_dBm = sys_params.noise_power_primary_user_per_Hz_dBm + sys_params.system_bandwidth_dB; 

sys_params.noise_power_primary_user_watts = dBm2watts(sys_params.noise_power_primary_user_dBm);

sys_params.max_antenna_gain_primary_user = dB2pow(sys_params.max_antenna_gain_primary_user_dB);


%% protected, primary satellite
sys_params.max_antenna_gain_primary_satellite = dB2pow(sys_params.max_antenna_gain_primary_satellite_dB);

sys_params.EIRP_primary_satellite_dBW_Hz = -54.3; %-57.7 would be the right value from my calculation, but rely on this setting for now; %at altitude 540 km ///// -54.3; %54.3; 
sys_params.EIRP_primary_satellite_dBm_Hz = sys_params.EIRP_primary_satellite_dBW_Hz + 30 ; 
sys_params.EIRP_primary_satellite_dBm = sys_params.EIRP_primary_satellite_dBm_Hz + 10*log10(sys_params.system_bandwidth);

sys_params.transmit_power_primary_satellite_dBm = sys_params.EIRP_primary_satellite_dBm - sys_params.max_antenna_gain_primary_satellite_dB;
sys_params.transmit_power_primary_satellite_watts = dBm2watts(sys_params.transmit_power_primary_satellite_dBm);


[Gtx_primary_satellite,~] = satellite_tx_mask(sys_params.carrier_frequency,sys_params.max_antenna_gain_primary_satellite_dB, phi); 
[Gtx_secondary_satellite,~] = satellite_tx_mask(sys_params.carrier_frequency,sys_params.max_antenna_gain_secondary_satellite_dB, phi);
sys_params.Gtx_primary_satellite = dB2pow(Gtx_primary_satellite.Values); 
sys_params.Gtx_secondary_satellite = dB2pow(Gtx_secondary_satellite.Values);

[Grx_primary_user,~, ~] = user_rx_mask(sys_params.carrier_frequency, phi, 'Max Antenna Gain', sys_params.max_antenna_gain_primary_user_dB); 
sys_params.Grx_primary_user = dB2pow(Grx_primary_user.Values); 
[Grx_secondary_user,~, ~] = user_rx_mask(sys_params.carrier_frequency,phi, 'Max Antenna Gain', sys_params.max_antenna_gain_secondary_user_dB); 
sys_params.Grx_secondary_user = dB2pow(Grx_secondary_user.Values); 
[Grx_measurement_user,~, ~] = user_rx_mask(sys_params.carrier_frequency,phi, 'Max Antenna Gain', sys_params.max_antenna_gain_measurement_user_dB); 
sys_params.Grx_measurement_user = dB2pow(Grx_measurement_user.Values); 

sys_params.phi =  phi'; % 0:0.0001:180;

