function primary_secondary_system_simulation(folder_name, sampling_time, sim_period, primary_policy, secondary_policy, ...
    ho_freq, cell_grouping_policy, protection_required, mask, num_active_beams, num_pserving)

    % rng = 3.2156;  %d
    % delta = 0.1; 
    
    
    %% ==================== Setup simulation parameters ======================
    % ----1) designate data/results saving folders per sym. parameters 
    % ----2) load satellite constellations
    % ----3) determine ground cells and their ecef/lla location coordinates
    % ========================================================================
    
    [Settings, kuiper_fn, spacex_fn] = setup_simulations(folder_name, sampling_time, sim_period, ...
        primary_policy, secondary_policy, ho_freq,cell_grouping_policy,num_active_beams, num_pserving);
    load(fullfile(Settings.ConstellationFolder, kuiper_fn),'k_loc') ; 
    load(fullfile(Settings.ConstellationFolder, spacex_fn),'space_loc') ; 

    [~, num_tsample, ~] = size(space_loc); 
    
    global sys_params;
    sys_params.mask = mask; 
    phi = (0:0.01:180); % off-angle from the antenna boresight
    run('geo_loc_params.m');  % geo location parameters 
    run('sym_param_set'); 
    run( 'system_parameters');

    psat_min_ele = 40; 
    ksat_min_ele = 35; 
    
    
    %% ================ Setup satellites/cells/primary system =================
    % -----1) determine overhead primary and secondary satellties ---------------
    % -----2) primary and secondary satellite-cell association per primary system policy ------
    % ============================================================================

  
    if ~exist(fullfile(Settings.ConstellationFolder, 'p_ecef_cell_locations.mat'),'file')  
        [s_lla_cell_loc, s_ecef_cell_locations, ~, ~]=...
             ground_cell_deployment(austin_lat, austin_lon, cell_radius_km,3);
        [p_lla_cell_loc, p_ecef_cell_locations, total_cells_band, cell_segment]=...
            ground_cell_deployment(austin_lat, austin_lon, cell_radius_km, 3);       


        ecef_secondary_users = s_ecef_cell_locations; 
        ecef_primary_users = p_ecef_cell_locations; 

        save(fullfile(Settings.ConstellationFolder, 'p_ecef_cell_locations'), 'p_ecef_cell_locations'); 
        save(fullfile(Settings.ConstellationFolder, 's_ecef_cell_locations'), 's_ecef_cell_locations'); 
        save(fullfile(Settings.ConstellationFolder, 'p_lla_cell_loc'), 'p_lla_cell_loc'); 
        save(fullfile(Settings.ConstellationFolder, 's_lla_cell_loc'), 's_lla_cell_loc'); 
        save(fullfile(Settings.ConstellationFolder, 'total_cells_band'), 'total_cells_band'); 
        save(fullfile(Settings.ConstellationFolder, 'cell_segment'), 'cell_segment'); 
        save(fullfile(Settings.ConstellationFolder, 'ecef_primary_users'), 'ecef_primary_users');
        save(fullfile(Settings.ConstellationFolder, 'ecef_secondary_users'), 'ecef_secondary_users');
    else
        load(fullfile(Settings.ConstellationFolder, 'p_ecef_cell_locations'), 'p_ecef_cell_locations'); 
        load(fullfile(Settings.ConstellationFolder, 's_ecef_cell_locations'), 's_ecef_cell_locations'); 
        load(fullfile(Settings.ConstellationFolder, 'p_lla_cell_loc'), 'p_lla_cell_loc'); 
        load(fullfile(Settings.ConstellationFolder, 's_lla_cell_loc'), 's_lla_cell_loc'); 
        load(fullfile(Settings.ConstellationFolder, 'total_cells_band'), 'total_cells_band'); 
        load(fullfile(Settings.ConstellationFolder, 'cell_segment'), 'cell_segment'); 
        load(fullfile(Settings.ConstellationFolder, 'ecef_primary_users'), 'ecef_primary_users');
        load(fullfile(Settings.ConstellationFolder, 'ecef_secondary_users'), 'ecef_secondary_users');
    end

      % 
   % file_name1 = sprintf('psat_elevation_%s.mat',cell_grouping_policy);
   % file_name2 = sprintf('unique_psat%s.mat',cell_grouping_policy);
    file_name1 = 'psat_elevation.mat'; 
    file_name2 = 'unique_psat.mat'; 
    if ~exist(fullfile(Settings.ConstellationFolder,'psat_elevation.mat'), 'file')
        psat_elevation = get_elevation_angles(space_loc, p_ecef_cell_locations); 
        [~,~,psat_in_view] = ind2sub(size(psat_elevation), find(psat_elevation>=psat_min_ele));
        unique_psat = unique(psat_in_view); 
        save(fullfile(Settings.ConstellationFolder, 'psat_elevation'), 'psat_elevation', '-v7.3'); %  save_format)
        save(fullfile(Settings.ConstellationFolder, 'unique_psat'),'unique_psat');
    else 
        load(fullfile(Settings.ConstellationFolder, 'psat_elevation')); %,'psat_elevation') ; 
        load(fullfile(Settings.ConstellationFolder, 'unique_psat')); %, 'unique_psat'); 
    end

%     file_name1 = sprintf('ksat_elevation_%s.mat',cell_grouping_policy);
%     file_name2 = sprintf('unique_ksat%s.mat',cell_grouping_policy);
    file_name1 = 'ksat_elevation.mat'; 
    file_name2 = 'unique_ksat.mat'; 
    if ~exist(fullfile(Settings.ConstellationFolder, file_name1),'file')  
        ksat_elevation = get_elevation_angles(k_loc, s_ecef_cell_locations); 
        [~,~,ksat_in_view] = ind2sub(size(ksat_elevation), find(ksat_elevation>=ksat_min_ele));
        unique_ksat = unique(ksat_in_view); 
        save(fullfile(Settings.ConstellationFolder, file_name1), 'ksat_elevation', '-v7.3'); 
        save(fullfile(Settings.ConstellationFolder, file_name2),'unique_ksat');
 
    else
   
        load(fullfile(Settings.ConstellationFolder, 'ksat_elevation')); % , 'ksat_elevation'); 
        load(fullfile(Settings.ConstellationFolder, 'unique_ksat')); %, 'unique_ksat'); 
    end

    if ~exist(fullfile(Settings.DataFolder,'cell_priorities.mat'), 'file')
        [cell_priorities, cell_centers] = cell_clustering(cell_grouping_policy); %'2a/b/c/d', '4a', '4b', '8a', '8b', '16a'
        save(fullfile(Settings.DataFolder,'cell_priorities'), 'cell_priorities');
        save(fullfile(Settings.DataFolder, 'cell_centers'), 'cell_centers');

        [cell_priorities, cell_centers] = cell_clustering(cell_grouping_policy); %'2a/b/c/d', '4a', '4b', '8a', '8b', '16a'
        [num_priority_groups, dum] = size(cell_priorities);
        cell_groups = zeros(num_priority_groups * 3,30); 

       for idx_f=1:3              
           for idx_g=1:num_priority_groups
            cell_list1 = nonzeros(cell_priorities(idx_g, :)); 
            idx = num_priority_groups* (idx_f-1) + idx_g; 
            cell_list2 = nonzeros(cell_segment(idx_f, :));
            eff_cell_list = cell_list1(ismember(cell_list1, cell_list2));
            cell_groups(idx, 1:length(eff_cell_list)) = eff_cell_list; 
            cell_groups_centers(idx) = cell_centers(idx_g); 
            end
       
       end
    
        save(fullfile(Settings.DataFolder, 'cell_groups'), 'cell_groups'); 
        save(fullfile(Settings.DataFolder, 'cell_groups_centers'), 'cell_groups_centers'); 
    else
        load(fullfile(Settings.DataFolder,'cell_priorities'), 'cell_priorities');
        load(fullfile(Settings.DataFolder,'cell_centers'), 'cell_centers');
        load(fullfile(Settings.DataFolder, 'cell_groups'), 'cell_groups'); 
        load(fullfile(Settings.DataFolder, 'cell_groups_centers'), 'cell_groups_centers'); 
    end

   % run('load_satellite_elevation_association'); 

    if ~exist(fullfile(Settings.DataFolder, 'primary_cell_sat_association.mat'), 'file')
         [primary_cell_sat_association, primary_cell_group, overhead_p_sats, ~, ~, ~, ~]...
             = determine_satellite_cell_association(primary_policy, ...
                psat_elevation, space_loc, num_tsample, ho_freq, total_cells_band, cell_priorities, cell_centers,p_ecef_cell_locations,40); %    
     
         save(fullfile(Settings.DataFolder, 'primary_cell_sat_association.mat '), 'primary_cell_sat_association');
         save(fullfile(Settings.DataFolder,'primary_cell_group.mat'), 'primary_cell_group'); 
         save(fullfile(Settings.DataFolder, 'overhead_p_sats.mat'), 'overhead_p_sats'); 
         
    else
         load(fullfile(Settings.DataFolder, 'primary_cell_sat_association.mat'), 'primary_cell_sat_association');
         load(fullfile(Settings.DataFolder, 'overhead_p_sats.mat'), 'overhead_p_sats'); 
         load(fullfile(Settings.DataFolder,'primary_cell_group.mat'), 'primary_cell_group'); 
    
    end

   if ~exist(fullfile(Settings.DataFolder, 'secondary_cell_sat_association.mat'), 'file')
         [secondary_cell_sat_association, secondary_cell_group, overhead_k_sats, ~, ~, ~, ~]...
             = determine_satellite_cell_association(secondary_policy, ...
                 ksat_elevation, k_loc, num_tsample, ho_freq, total_cells_band, cell_priorities, cell_centers, s_ecef_cell_locations,35); %

         save(fullfile(Settings.DataFolder, 'secondary_cell_sat_association.mat '), 'secondary_cell_sat_association');
         save(fullfile(Settings.DataFolder, 'secondary_cell_group.mat '), 'secondary_cell_group');
         save(fullfile(Settings.DataFolder, 'overhead_k_sats.mat '), 'overhead_k_sats');
         
    else
         load(fullfile(Settings.DataFolder, 'secondary_cell_sat_association.mat'), 'secondary_cell_sat_association');
         load(fullfile(Settings.DataFolder, 'overhead_k_sats.mat'), 'overhead_k_sats');

    end



    if ~protection_required  
        % To get individual system performance where
        % - each system employes its own serving satellite selection policy, e.g. HE  or MCT. 
        % Outputs of the function: 
        % - primary_snr: primary users' snr
        % - primary_intra_inr: primary users' inr considering intra-system interference only (spot beam interference)
        % - primary_inter_inr: primary users' inr considering inter-system interference only (interference coming 
        %    from the secondary system)
        % - primary_intra_sinr: primary users' sinr based on primary_snr
        % and primary_intra_inr
        % - primary_inter_sinr: primary users' sinr based on primary_snr
        % and primary_inter_inr
        % - secondary_snr, secondary_intra_inr, secondary_inter_inr
        % - secondary_sinr, secondary_intra_sinr, secondary_inter_sinr
  
        get_individual_system_performance_paa(Settings, sys_params, space_loc, k_loc, ...
                psat, ksat, pusr, susr, overhead_p_sats, overhead_k_sats,...
                primary_cell_sat_association, secondary_cell_sat_association, total_cells_band, ...
                p_ecef_cell_locations,s_ecef_cell_locations, cell_priorities,...
                ecef_secondary_users,ecef_primary_users, num_active_beams)
    
    else 
        % To collect exhaustive values of potential system performance where
        % - the primary system employs designated satellite selection olicy, i.e. HE, 
        % - the secondary system's performance depending on each secondary
        % satellite being the serving satellite given the primary serving
        % sastellite selection is already made
        % Outputs of the function: The outputs contain an exhaustive set of potential link metrics, computed by assuming each available secondary satellite is
        % individually selected as the serving satellite.
        % - ncoex_s_snr: secondary users[ potential SNR for each candidate secondary satellite acting as the serving satellite.
        % - ncoex_p_inr: primary usersp potential INR for each candidate secondary satellite acting as the serving satellite.
        % - ncoex_s_inr: secondary userss potential INR for each candidate secondary satellite acting as the serving satellite.
        % - ncoex_s_sinr

        take_satellite_measurements(Settings, sys_params, space_loc, k_loc, ...
            psat, ksat, overhead_p_sats, overhead_k_sats, ...
            primary_cell_sat_association, total_cells_band, p_ecef_cell_locations,s_ecef_cell_locations,...
            ecef_primary_users, ecef_secondary_users, pusr, susr, cell_priorities,num_active_beams);
  

    end 
end
