function take_satellite_measurements_r1_mod(Settings, sys_params, ...
    psat, ksat, overhead_psats, overhead_ksats, ...
    primary_cell_sat_association, total_cells_band, p_ecef_cell_locations,...
    s_ecef_cell_locations, ecef_primary_users, ecef_secondary_users, pusr, susr, cell_priorities, num_active_beams)
    % 
    % num_psat_in_view = length(unique_psat); 
    % num_ksat_in_view = length(unique_ksat);
%     [~, num_tsample, Np] = size(space_loc); 
%     [~, ~, Nk] = size(k_loc); 

     % num_cell_groups: number of cells using the same frequency 
    [num_cell_groups,~]= size(cell_priorities); 

    num_tsample = 1800; % 3*60 / 0.1sec, [duration 3 min, sampling time 0.1 sec] 
    % 
    % idx_t_list= 1:30:num_tsample*16; 
    % num_tsample = length(idx_t_list); 

    [num_primary_users,~] = size(ecef_primary_users);
    [num_secondary_users,~] = size(ecef_secondary_users);

    ncoex_s_snr = zeros(num_tsample, num_primary_users, 50, num_cell_groups); 
    ncoex_p_inr = zeros(num_tsample,  num_primary_users, 50, num_cell_groups); 
    ncoex_s_inr = zeros(num_tsample,  num_primary_users, 50, num_cell_groups); 
  
    % load(fullfile(Settings.ResultsFolder, 'coex_s_snr.mat'), 'coex_s_snr'); 
    % load(fullfile(Settings.ResultsFolder, 'coex_p_inr.mat'), 'coex_p_inr');
    % load(fullfile(Settings.ResultsFolder, 'coex_s_inr.mat'), 'coex_s_inr'); 


    eligible_sats_to_consider = zeros(num_tsample, 50); 

    for idx_cell=1:num_primary_users
        pu = copy_object(pusr); 
        pu.location = ecef_primary_users(idx_cell, :); 
        primary_users{idx_cell} = pu; 
        su = copy_object(susr); 
        su.location = ecef_secondary_users(idx_cell, :); 
        secondary_users{idx_cell} = su; 
    end


    for idx_f=1:1
        cells_per_freq_band = total_cells_band(idx_f, :); 
        
        
        for idx_const=1:3
            spacex_fn = sprintf('space_loc%d.mat',idx_const);
            kuiper_fn = sprintf('k_loc%d.mat',idx_const);

            load(fullfile(Settings.ConstellationFolder, kuiper_fn),'k_loc') ; 
            load(fullfile(Settings.ConstellationFolder, spacex_fn),'space_loc') ; 

            [~, num_tsample, ~] = size(space_loc); 
       
            for idx_tt=1:num_tsample % 30:num_tsample*16
                 idx_t = (idx_const - 1) * num_tsample + idx_tt; 
    
    
                unique_psat = nonzeros(overhead_psats(idx_t, :)); 
                num_psat_in_view = length(unique_psat); 
                unique_ksat = nonzeros(overhead_ksats(idx_t, :)); 
                num_ksat_in_view = length(unique_ksat); 
    
                primary_sat_loc = reshape(space_loc(:, idx_tt, unique_psat), 3, num_psat_in_view)';
                secondary_sat_loc = reshape(k_loc(:, idx_tt, unique_ksat), 3, num_ksat_in_view)'; 
                
               %load(fullfile(Settings.DataFolder,'primary_cell_group.mat'), 'primary_cell_group'); 
      
                psat_association = primary_cell_sat_association(idx_t, :, :); % (num_tsample, num_p_serving, num_group)
    
                %for ps=1:num_pserving               
                   % potential_psat_association = psat_association(ps, :);
                    primary_satellites = psat_max_gain_setting_r1(sys_params, psat, unique_psat, primary_sat_loc); 
                    secondary_satellites = ksat_max_gain_setting(sys_params, ksat,unique_ksat, secondary_sat_loc);
    
                    % steer primary satellit beams toward associated ground cells 
                   [primary_satellites, primary_users] = steer_primary_satelllites_to_ground_cells_r1(primary_sat_loc, primary_satellites,...
                        primary_users, psat_association, p_ecef_cell_locations, cell_priorities, unique_psat); 
         
           
                   [primary_inr, secondary_inr, secondary_snr, sats_to_consider] = est_primary_system_rx_power_r4(sys_params, unique_psat,unique_ksat, ...
                       primary_satellites, secondary_satellites,primary_users, secondary_users,psat_association, ...
                       p_ecef_cell_locations, s_ecef_cell_locations,cells_per_freq_band,cell_priorities, num_active_beams);
         
    
                   ncoex_p_inr(idx_t,  :, :, :) = single(primary_inr);
                   ncoex_s_inr(idx_t, :, :,:) = single(secondary_inr); 
     
                %end
    
                ncoex_s_snr(idx_t,  :, :,:) = single(secondary_snr); % 
                eligible_sats_to_consider(idx_t, 1:length(sats_to_consider)) = sats_to_consider; 
           
                %coex_s_sinr = coex_s_snr./(1 + coex_s_inr); 
                if mod(idx_t,100)==1
                    save_format = '-v7.3'; 
                    ncoex_s_sinr = ncoex_s_snr./(1 + ncoex_s_inr); 
                    save(fullfile(Settings.ResultsFolder, 'ncoex_s_snr'),'ncoex_s_snr', save_format ); 
                    save(fullfile(Settings.ResultsFolder, 'ncoex_p_inr'),'ncoex_p_inr', save_format);
                    save(fullfile(Settings.ResultsFolder, 'ncoex_s_inr'),'ncoex_s_inr', save_format);
                    save(fullfile(Settings.ResultsFolder, 'ncoex_s_sinr'),'ncoex_s_sinr', save_format);
                    save(fullfile(Settings.ResultsFolder,'eligible_sats_to_consider'), 'eligible_sats_to_consider', save_format)
                end

                
                disp(['ending time index=', num2str(idx_t), ', at ', datestr(datetime('now'))]); 
            
            end
            space_loc = []; 
            kuiper_loc = []; 

        
        end

    end
        ncoex_s_sinr = ncoex_s_snr./(1 + ncoex_s_inr); 
   
        save_format = '-v7.3'; 
        save(fullfile(Settings.ResultsFolder, 'ncoex_s_snr'),'ncoex_s_snr', save_format ); 
        save(fullfile(Settings.ResultsFolder, 'ncoex_p_inr'),'ncoex_p_inr', save_format);
        save(fullfile(Settings.ResultsFolder, 'ncoex_s_inr'),'ncoex_s_inr', save_format);
        save(fullfile(Settings.ResultsFolder, 'ncoex_s_sinr'),'ncoex_s_sinr', save_format);
        save(fullfile(Settings.ResultsFolder,'eligible_sats_to_consider'), 'eligible_sats_to_consider', save_format)


end 