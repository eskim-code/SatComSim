function [secondary_cell_sat_association, secondary_cell_group, overhead_sats, overhead_sats_rel, overhead_psat_ecef, overhead_psat_lla, overhead_psat_ele]...
= determine_satellite_cell_association(secondary_policy, ...
    ksat_elevation, k_loc, num_tsample, ho_freq, total_cells_band, cell_priorities, cell_centers,ecef_cell_locations, min_elevation) %  primary_cells_per_fband, num_primary_cells_per_band)


        if strcmp(secondary_policy,'HE') 
            [secondary_cell_sat_association, secondary_cell_group, overhead_sats, overhead_sats_rel, overhead_psat_ecef, overhead_psat_lla, overhead_psat_ele]...
                = HE_association(ksat_elevation, k_loc,num_tsample, ho_freq, total_cells_band, cell_priorities, cell_centers, min_elevation);

        elseif strcmp(secondary_policy,'MCT') 
              [secondary_cell_sat_association, secondary_cell_group, overhead_sats, overhead_sats_rel, overhead_psat_ecef, overhead_psat_lla, overhead_psat_ele]...
             = MCT_association(ksat_elevation, k_loc,  num_tsample, ho_freq, total_cells_band, cell_priorities, cell_centers,...
             ecef_cell_locations, min_elevation);

        end


end
