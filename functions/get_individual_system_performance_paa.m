function get_individual_system_performance_paa_r1(Settings, sys_params, space_loc, k_loc, ...
    psat, ksat, pusr, susr, overhead_psats, overhead_ksats,...
    primary_cell_sat_association, secondary_cell_sat_association, total_cells_band, ...
    p_ecef_cell_locations,s_ecef_cell_locations, cell_priorities,...
    ecef_secondary_users,ecef_primary_users, num_active_beams)
    % 
    
    [~, num_tsample, Np] = size(space_loc); 

    save_format = '-v7.3'; 
    
    %num_tsample = 10;
  
    % [~, ~, Nk] = size(k_loc); 
    %[num_fband, ~] = size(total_cells_band); 
    [num_primary_users,~] = size(ecef_primary_users);
    [num_secondary_users,~] = size(ecef_secondary_users);


    primary_snr = zeros(num_tsample, num_primary_users); 
    secondary_snr = zeros(num_tsample, num_secondary_users);

    primary_intra_inr = zeros(num_tsample, num_primary_users); %, num_ksat_in_view, num_cells_per_band); 
    primary_inter_inr = zeros(num_tsample, num_primary_users); %, num_ksat_in_view, num_cells_per_band); 

    secondary_intra_inr = zeros(num_tsample, num_secondary_users); %, num_ksat_in_view); 
    secondary_inter_inr = zeros(num_tsample, num_secondary_users); %, num_ksat_in_view); 


    for idx_cell=1:num_primary_users
        pu = copy_object(pusr); 
        pu.location = ecef_primary_users(idx_cell, :); 
        primary_users{idx_cell} = pu; 
        su = copy_object(susr); 
        su.location = ecef_secondary_users(idx_cell, :); 
        secondary_users{idx_cell} = su; 
    end

    %num_tsample = 10; 

    for idx_f=1:1
        cells_per_freq_band = nonzeros(total_cells_band(idx_f, :)); 
   
        for idx_t=1: num_tsample     

            unique_psat = nonzeros(overhead_psats(idx_t, :)); 
            num_psat_in_view = length(unique_psat); 
            unique_ksat = nonzeros(overhead_ksats(idx_t, :)); 
            num_ksat_in_view = length(unique_ksat); 

            primary_sat_loc = reshape(space_loc(:, idx_t, unique_psat), 3, num_psat_in_view)';
            secondary_sat_loc = reshape(k_loc(:, idx_t, unique_ksat), 3, num_ksat_in_view)'; 
            
            primary_satellites = psat_max_gain_setting(sys_params, psat, unique_psat, primary_sat_loc); 
            secondary_satellites = ksat_max_gain_setting(sys_params, ksat, unique_ksat, secondary_sat_loc);

            psat_association = primary_cell_sat_association(idx_t, :);
            ksat_association = secondary_cell_sat_association(idx_t, :); 

            [primary_satellites, primary_users] = steer_primary_satelllites_to_ground_cells(primary_sat_loc, primary_satellites,...
                primary_users,psat_association, p_ecef_cell_locations, cell_priorities, unique_psat); 
            
            [secondary_satellites, secondary_users] = steer_primary_satelllites_to_ground_cells(secondary_sat_loc, secondary_satellites,...
                secondary_users,ksat_association, s_ecef_cell_locations, cell_priorities, unique_ksat); 



            [p_snr_t, s_snr_t, p_intra_inr_t, p_inter_inr_t, s_intra_inr_t, s_inter_inr_t] =...
                get_inter_system_inr_based_on_satellite_association_paa(sys_params, primary_satellites, secondary_satellites, ...
                primary_users, secondary_users, unique_psat, unique_ksat, psat_association,ksat_association,...
                p_ecef_cell_locations,  cells_per_freq_band, cell_priorities, num_active_beams);



          
            primary_snr(idx_t,:) = p_snr_t; 
            primary_intra_inr(idx_t,:) = p_intra_inr_t;
            primary_inter_inr(idx_t,:) = p_inter_inr_t;
            
            secondary_snr(idx_t,:) = s_snr_t; 
            secondary_intra_inr(idx_t,:) = s_intra_inr_t;
            secondary_inter_inr(idx_t,:) = s_inter_inr_t;
   
            disp(['ending time index=', num2str(idx_t), ', at ', datestr(datetime('now'))]); 
           
            if mod(idx_t,40)==1
                primary_inter_sinr = primary_snr./(1 + primary_inter_inr); 
                secondary_inter_sinr = secondary_snr./( 1+ secondary_inter_inr);

                save(fullfile(Settings.ResultsFolder, 'primary_snr'),'primary_snr', save_format);
                save(fullfile(Settings.ResultsFolder, 'primary_inter_inr'),'primary_inter_inr', save_format);
                
                save(fullfile(Settings.ResultsFolder, 'secondary_snr'),'secondary_snr', save_format);
                save(fullfile(Settings.ResultsFolder, 'secondary_inter_inr'),'secondary_inter_inr', save_format);

                save(fullfile(Settings.ResultsFolder, 'primary_inter_sinr'),'primary_inter_sinr', save_format);
                save(fullfile(Settings.ResultsFolder, 'secondary_inter_sinr'),'secondary_inter_sinr', save_format);
            end

        end

    end

    primary_intra_sinr = primary_snr./(1+primary_intra_inr); 
    primary_inter_sinr = primary_snr./(1 + primary_inter_inr); 
    primary_sinr = primary_snr./(1+ primary_intra_inr + primary_inter_inr); 

    secondary_intra_sinr = secondary_snr./(1 + secondary_intra_inr); 
    secondary_inter_sinr = secondary_snr./( 1+ secondary_inter_inr); 
    secondary_sinr = secondary_snr./( 1+ secondary_intra_inr + secondary_inter_inr); 

% 
%     memory_size = num_tsample * num_primary_users; 
%     two_gb_limit = 2 * 1024^3; 

    %if memory_size > two_gb_limit
    save_format = '-v7.3'; 
    %else
    %    save_format = '-v7'; 
    %end
    save(fullfile(Settings.ResultsFolder, 'primary_snr'),'primary_snr', save_format);
    save(fullfile(Settings.ResultsFolder, 'primary_intra_inr'),'primary_intra_inr', save_format);
    save(fullfile(Settings.ResultsFolder, 'primary_inter_inr'),'primary_inter_inr', save_format);
    
    save(fullfile(Settings.ResultsFolder, 'secondary_snr'),'secondary_snr', save_format);
    save(fullfile(Settings.ResultsFolder, 'secondary_intra_inr'),'secondary_intra_inr', save_format);
    save(fullfile(Settings.ResultsFolder, 'secondary_inter_inr'),'secondary_inter_inr', save_format);

    save(fullfile(Settings.ResultsFolder, 'primary_intra_sinr'),'primary_intra_sinr', save_format);
    save(fullfile(Settings.ResultsFolder, 'primary_inter_sinr'),'primary_inter_sinr', save_format);
    save(fullfile(Settings.ResultsFolder, 'primary_sinr'),'primary_sinr', save_format);


    save(fullfile(Settings.ResultsFolder, 'secondary_sinr'),'secondary_sinr', save_format);
    save(fullfile(Settings.ResultsFolder, 'secondary_intra_sinr'),'secondary_intra_sinr', save_format);
    save(fullfile(Settings.ResultsFolder, 'secondary_inter_sinr'),'secondary_inter_sinr', save_format);

end 