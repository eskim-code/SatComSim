function sat_elevation = get_elevation_angles(sat_locs, ecef_cell_locations)
    [~, num_tsample, N] = size(sat_locs); 
    [num_cells, ~] = size(ecef_cell_locations); 
    sat_elevation = single(zeros(num_tsample, num_cells, N)); 

    for idx_t=1: num_tsample
        sat_loc = reshape(sat_locs(:, idx_t, :), 3, N)';
        
        for idx_cell=1:num_cells
            cell_cnt = ecef_cell_locations(idx_cell,:); 
            sat_elevation(idx_t, idx_cell, :) = single(return_elevation_sats(sat_loc, cell_cnt, cell_cnt, [0,0,0]));
        end
        
    end
end
