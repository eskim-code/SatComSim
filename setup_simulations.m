function [Settings, kuiper_fn, spacex_fn] = setup_simulations(folder_name, sampling_time,...
    sim_period, primary_policy, secondary_policy, ho_freq, cell_grouping_policy, num_active_beams, num_pserving)

% Inputs - constellation/primary_policy/HO freq. simulation variables 
% sampling_time = 1; 
% sim_period = 5; 
% primary_policy = 'HE';
% ho_freq = 15;


    % Designate results path
    psystem_config = {folder_name, sampling_time, sim_period, primary_policy, secondary_policy, ho_freq, cell_grouping_policy,num_active_beams, num_pserving}; 
    Settings = initial_path(psystem_config); 
    
    %% Load desired satellite constellation data 
    kuiper_fn = ['kuiper_', num2str(sampling_time), 's_', num2str(sim_period), 'm.mat'];
    spacex_fn = ['spacex_', num2str(sampling_time), 's_', num2str(sim_period), 'm.mat'];
    
    % generate satellite locations if not exist  
    if ~exist(fullfile(Settings.ConstellationFolder,spacex_fn), 'file')
       %sampling_satellite_locations_r1(Settings, sim_period, sampling_time); 
       sampling_satellite_locations_gen2(Settings, sim_period, sampling_time);
    end 
    

end