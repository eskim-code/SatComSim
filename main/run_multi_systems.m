
folder_name = 'Data_folder'; % This is a folder name your data files are saved. 
mask = false; 


cell_grouping_policy_list = {'ra'}; % cell-layout scenario, 'ra'
primary_policy_list = { 'HE'}; %, 
secondary_policy_list = {'HE'}; %,

%% -------- Values for simulation run time and sampling time of satellite locations --------
% 
% Values to collect practical evaluation results, for example, 
% [sim_period = 3 (min., at least), sampling_time = 0.1 (sec), ho_freq = 150 (assuming handover period to be 15 sec.]
% However, simulating with these values requires extensive computing power
% and memory size to run. 

sim_period = 1; % 
sampling_time= 30 ;% sec
num_active_beams_list = [16]; %,24,32,8];
num_pserving=1; 
ho_freq = 30; % number of samples [15 sec/ sampling_time]
protection_required = true;

for i = 1: length(primary_policy_list)
    primary_policy = primary_policy_list{i};
    for j=1:length(secondary_policy_list)
        secondary_policy = secondary_policy_list{j};
        for k=1:length(cell_grouping_policy_list)   
            for b=1:length(num_active_beams_list)
                num_active_beams = num_active_beams_list(b);
                primary_secondary_system_simulation(folder_name, sampling_time, sim_period, primary_policy, secondary_policy, ...
                ho_freq, cell_grouping_policy_list{k}, protection_required, mask, num_active_beams, num_pserving);
            end
        end

    end
end
